#!/usr/bin/env python3
"""
PATH 环境变量管理工具
支持 Windows 和 macOS 系统的 PATH 环境变量统一管理
Author: Assistant
Date: 2025-10-17
Version: 1.0
"""

import os
import sys
import platform
import subprocess
from pathlib import Path

class PathUtils:
    """PATH 工具类，提供跨平台的 PATH 管理功能"""

    def __init__(self):
        self.system = platform.system().lower()
        self.is_windows = self.system == 'windows'
        self.is_mac = self.system == 'darwin'
        self.path_separator = ';' if self.is_windows else ':'

        # 获取当前 PATH
        self.current_path = os.environ.get('PATH', '')
        self.current_path_list = self._get_clean_path_list()

    def _get_clean_path_list(self):
        """获取清理后的 PATH 列表（去除空值和重复项）"""
        paths = self.current_path.split(self.path_separator)
        # 去除空字符串和重复项，同时保持顺序
        seen = set()
        clean_list = []
        for path in paths:
            if path.strip() and path not in seen:
                seen.add(path)
                clean_list.append(path)
        return clean_list

    def path_exists(self, search_path):
        """检查路径是否已在当前 PATH 中存在[3,4](@ref)

        Args:
            search_path: 要检查的路径

        Returns:
            bool: 如果路径存在返回 True，否则返回 False
        """
        try:
            # 标准化路径进行比较[3](@ref)
            search_path = str(Path(search_path).resolve())
            for existing_path in self.current_path_list:
                if existing_path.strip():
                    try:
                        existing_resolved = str(Path(existing_path).resolve())
                        if existing_resolved == search_path:
                            return True
                    except OSError:
                        # 如果路径无效，继续检查下一个
                        continue
        except Exception as e:
            print(f"检查路径时出错: {e}")

        return False

    def add_path_permanent(self, new_path):
        """将路径永久添加到系统 PATH[9,10](@ref)

        Args:
            new_path: 要添加的新路径

        Returns:
            bool: 添加成功返回 True，否则返回 False
        """
        try:
            # 展开路径中的环境变量和用户目录[4](@ref)
            expanded_path = os.path.expanduser(os.path.expandvars(new_path))

            # 检查路径是否已存在[4](@ref)
            if self.path_exists(expanded_path):
                print(f"路径已存在，跳过: {expanded_path}")
                return True

            # 检查路径是否存在（物理路径）
            if not os.path.exists(expanded_path):
                print(f"警告: 路径 '{expanded_path}' 不存在")
                response = input("是否继续添加？(y/N): ").lower()
                if response not in ('y', 'yes'):
                    return False

            # 根据系统选择不同的永久添加方法
            if self.is_windows:
                return self._add_path_windows_permanent(expanded_path)
            elif self.is_mac:
                return self._add_path_mac_permanent(expanded_path)
            else:
                print(f"不支持的操作系统: {self.system}")
                return False

        except Exception as e:
            print(f"添加路径时出错: {e}")
            return False

    def _add_path_windows_permanent(self, new_path):
        """在 Windows 系统永久添加路径[9,10](@ref)"""
        try:
            # 获取当前用户的环境变量 PATH
            try:
                result = subprocess.run(
                    ['reg', 'query', 'HKCU\\Environment', '/v', 'Path'],
                    capture_output=True, text=True, shell=True, timeout=10
                )
                if result.returncode == 0:
                    # 解析注册表中的 PATH
                    lines = result.stdout.split('\n')
                    for line in lines:
                        if 'REG' in line and 'PATH' in line.upper():
                            current_path = line.split('REG_')[1].split(' ', 1)[-1].strip()
                            break
                    else:
                        current_path = os.environ.get('PATH', '')
                else:
                    current_path = os.environ.get('PATH', '')
            except (subprocess.TimeoutExpired, subprocess.CalledProcessError, IndexError):
                current_path = os.environ.get('PATH', '')

            # 构建新的 PATH（避免重复）
            path_list = current_path.split(';')
            if new_path not in path_list:
                path_list.append(new_path)
                new_path_str = ';'.join([p for p in path_list if p.strip()])

                # 使用 setx 命令永久设置 PATH[10](@ref)
                result = subprocess.run(
                    ['setx', 'PATH', new_path_str],
                    capture_output=True, text=True, timeout=30
                )

                if result.returncode == 0:
                    print(f"已永久添加路径到 PATH: {new_path}")
                    print("注意: 需要重新启动终端或重新登录才能使更改生效")
                    return True
                else:
                    print(f"设置 PATH 失败: {result.stderr}")
                    return False
            else:
                print(f"路径已在 PATH 中存在: {new_path}")
                return True

        except Exception as e:
            print(f"Windows PATH 设置出错: {e}")
            return False

    def _add_path_mac_permanent(self, new_path):
        """在 macOS 系统永久添加路径[9,11](@ref)"""
        try:
            # 确定 shell 类型和配置文件[11](@ref)
            shell = os.environ.get('SHELL', '')
            if 'zsh' in shell:
                config_file = Path.home() / '.zshrc'
                shell_name = 'zsh'
            else:  # bash
                config_file = Path.home() / '.bash_profile'
                shell_name = 'bash'

            print(f"检测到 Shell: {shell_name}, 配置文件: {config_file}")

            # 检查是否已存在相同的导出语句
            export_line = f'export PATH="{new_path}:$PATH"'

            if config_file.exists():
                with open(config_file, 'r') as f:
                    content = f.read()

                if export_line in content:
                    print(f"路径配置已存在: {new_path}")
                    return True
            else:
                content = ""
                # 创建配置文件
                config_file.parent.mkdir(parent_ok=True, exist_ok=True)

            # 添加路径到配置文件
            with open(config_file, 'a') as f:
                f.write(f'\n# Added by PathUtils - {platform.node()} {platform.system()}\n')
                f.write(f'{export_line}\n')

            print(f"路径已添加到配置文件: {config_file}")
            print(f"请运行以下命令使其立即生效: source {config_file.name}")

            return True

        except Exception as e:
            print(f"macOS PATH 设置出错: {e}")
            return False

    def show_current_path(self, show_all=False):
        """显示当前 PATH 信息[4](@ref)

        Args:
            show_all: 是否显示所有路径（如果路径很多）
        """
        print(f"\n当前 PATH 环境变量 ({'Windows' if self.is_windows else 'macOS'}):")
        print("=" * 80)

        valid_paths = [path for path in self.current_path_list if path.strip()]

        if not show_all and len(valid_paths) > 20:
            print(f"显示前 20 个路径 (共 {len(valid_paths)} 个):")
            valid_paths = valid_paths[:20]
            print("使用 show_all=True 查看完整列表")

        for i, path in enumerate(valid_paths, 1):
            exists = "✓" if os.path.exists(path) else "✗"
            print(f"{i:2d}. [{exists}] {path}")

        print("=" * 80)
        return valid_paths

    def validate_paths(self, paths_to_check=None):
        """验证路径是否存在[4](@ref)

        Args:
            paths_to_check: 要验证的路径列表，如果为None则验证当前PATH中的所有路径

        Returns:
            tuple: (有效路径数量, 无效路径列表)
        """
        if paths_to_check is None:
            paths_to_check = self.current_path_list

        print(f"\n验证 {len(paths_to_check)} 个路径:")
        print("=" * 80)

        valid_count = 0
        invalid_paths = []

        for path in paths_to_check:
            if not path.strip():
                continue

            if os.path.exists(path):
                print(f"✓ {path}")
                valid_count += 1
            else:
                print(f"✗ {path}")
                invalid_paths.append(path)

        print("=" * 80)
        print(f"有效路径: {valid_count}/{len(paths_to_check)}")

        if invalid_paths:
            print(f"无效路径: {len(invalid_paths)}")
            for path in invalid_paths[:10]:  # 只显示前10个无效路径
                print(f"  - {path}")
            if len(invalid_paths) > 10:
                print(f"  ... 和 {len(invalid_paths) - 10} 个更多无效路径")

        return valid_count, invalid_paths

def main():
    """命令行主函数"""
    if len(sys.argv) < 2:
        print("用法: python path_utils.py <命令> [参数]")
        print("命令: show, add <路径>, validate")
        return

    utils = PathUtils()
    command = sys.argv[1].lower()

    if command == 'show':
        show_all = len(sys.argv) > 2 and sys.argv[2] == 'all'
        utils.show_current_path(show_all=show_all)

    elif command == 'add':
        if len(sys.argv) < 3:
            print("错误: 请指定要添加的路径")
            return

        path_to_add = sys.argv[2]
        utils.add_path_permanent(path_to_add)

    elif command == 'validate':
        utils.validate_paths()

    else:
        print(f"未知命令: {command}")

if __name__ == "__main__":
    main()