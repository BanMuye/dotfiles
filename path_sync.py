#!/usr/bin/env python3
"""
PATH 同步工具
根据当前系统自动同步预设的路径集合到系统 PATH
Author: Assistant
Date: 2025-10-17
Version: 1.0
"""

import os
import sys
import platform
from path_utils import PathUtils

class PathSynchronizer:
    """PATH 同步器，维护系统特定的路径集合并进行同步"""

    def __init__(self):
        self.system = platform.system().lower()
        self.is_windows = self.system == 'windows'
        self.is_mac = self.system == 'darwin'

        # 定义 Windows 和 macOS 特有的路径集合[9,10](@ref)
        self.windows_paths = {
            # # 常用 Windows 开发工具路径
            # r"C:\Program Files\Git\bin",
            # r"C:\Program Files\Git\cmd",
            # r"C:\Windows\System32",
            # r"C:\Windows",
            # r"C:\Program Files\Python311\Scripts",
            # r"C:\Program Files\Python311",
            # r"C:\Program Files\nodejs",
            # r"C:\Program Files\Java\jdk-21\bin",
            # # 用户 Python 路径
            # os.path.join(os.environ.get('USERPROFILE', ''), r"AppData\Local\Programs\Python\Python311\Scripts"),
            # os.path.join(os.environ.get('USERPROFILE', ''), r"AppData\Local\Programs\Python\Python311"),
            # # 添加其他 Windows 特有路径
        }

        self.mac_paths = {
            # # 常用 macOS 开发工具路径
            # "/usr/local/bin",
            # "/usr/local/sbin",
            # "/usr/bin",
            # "/usr/sbin",
            # "/bin",
            # "/sbin",
            # "/opt/homebrew/bin",
            # "/opt/homebrew/sbin",
            # "/Applications/Xcode.app/Contents/Developer/usr/bin",
            # # Homebrew 安装的软件路径
            # "/usr/local/opt/python@3.11/libexec/bin",
            # # Node.js 路径
            # "/usr/local/opt/node@18/bin",
            # # 用户自定义路径
            # os.path.expanduser("~/bin"),
            # os.path.expanduser("~/.local/bin"),
            # # 添加其他 macOS 特有路径
        }

        self.path_utils = PathUtils()
        print(f"系统检测: {'Windows' if self.is_windows else 'macOS'}")

    def get_target_paths(self):
        """获取当前系统的目标路径集合[9,10](@ref)

        Returns:
            set: 当前系统对应的路径集合
        """
        if self.is_windows:
            return self.windows_paths
        elif self.is_mac:
            return self.mac_paths
        else:
            print(f"警告: 不支持的操作系统 {self.system}，使用空集合")
            return set()

    def sync_paths(self, dry_run=False):
        """同步路径集合到系统 PATH[9,10](@ref)

        Args:
            dry_run: 试运行模式，只显示将要执行的操作而不实际执行

        Returns:
            tuple: (成功添加数量, 总处理数量, 跳过的数量)
        """
        target_paths = self.get_target_paths()
        print(f"\n开始同步路径集合 ({'Windows' if self.is_windows else 'macOS'})")
        print(f"目标路径数量: {len(target_paths)}")
        print("=" * 60)

        # 过滤出需要添加的路径（不存在的路径）
        paths_to_add = []
        skipped_paths = []

        for path in target_paths:
            # 展开路径中的环境变量和用户目录
            expanded_path = os.path.expanduser(os.path.expandvars(path))

            if not self.path_utils.path_exists(expanded_path):
                paths_to_add.append(expanded_path)
                status = "待添加"
            else:
                skipped_paths.append(expanded_path)
                status = "已存在"

            exists_marker = "✓" if os.path.exists(expanded_path) else "✗"
            print(f"{exists_marker} [{status}] {expanded_path}")

        if not paths_to_add:
            print("\n所有路径已存在，无需同步")
            return 0, len(target_paths), len(skipped_paths)

        print(f"\n需要添加 {len(paths_to_add)} 个新路径")
        print(f"跳过 {len(skipped_paths)} 个已存在路径")

        if dry_run:
            print("\n[试运行模式] 以下路径将被添加:")
            for path in paths_to_add:
                print(f"  - {path}")
            return len(paths_to_add), len(target_paths), len(skipped_paths)

        # 实际添加路径
        success_count = 0
        print("\n开始添加路径到系统 PATH...")

        for i, path in enumerate(paths_to_add, 1):
            print(f"\n[{i}/{len(paths_to_add)}] 处理: {path}")

            if self.path_utils.add_path_permanent(path):
                success_count += 1
            else:
                print(f"添加失败: {path}")

        print("\n" + "=" * 60)
        print(f"同步完成: 成功 {success_count}/{len(paths_to_add)}")

        if success_count == len(paths_to_add):
            print("所有路径添加成功！")
        else:
            print(f"{len(paths_to_add) - success_count} 个路径添加失败")

        return success_count, len(target_paths), len(skipped_paths)

    def show_target_paths(self):
        """显示目标路径集合"""
        target_paths = self.get_target_paths()
        print(f"\n目标路径集合 ({'Windows' if self.is_windows else 'macOS'}):")
        print("=" * 80)

        for i, path in enumerate(sorted(target_paths), 1):
            expanded_path = os.path.expanduser(os.path.expandvars(path))
            exists_in_path = "✓" if self.path_utils.path_exists(expanded_path) else "✗"
            exists_on_disk = "✓" if os.path.exists(expanded_path) else "✗"
            print(f"{i:2d}. [PATH:{exists_in_path} DISK:{exists_on_disk}] {path}")

        print("=" * 80)

    def add_custom_paths(self, custom_paths):
        """添加自定义路径到目标集合并进行同步

        Args:
            custom_paths: 自定义路径列表

        Returns:
            bool: 全部成功返回 True，否则返回 False
        """
        if self.is_windows:
            self.windows_paths.update(custom_paths)
        else:
            self.mac_paths.update(custom_paths)

        print(f"已添加 {len(custom_paths)} 个自定义路径")
        return self.sync_paths()

    def interactive_sync(self):
        """交互式同步模式"""
        print("PATH 同步工具 - 交互模式")
        print("=" * 50)

        while True:
            print("\n请选择操作:")
            print("1. 显示当前 PATH")
            print("2. 显示目标路径集合")
            print("3. 验证目标路径")
            print("4. 同步路径到系统 PATH")
            print("5. 试运行（显示将要执行的操作）")
            print("6. 添加自定义路径")
            print("7. 退出")

            try:
                choice = input("\n请输入选择 (1-7): ").strip()

                if choice == '1':
                    self.path_utils.show_current_path(show_all=True)

                elif choice == '2':
                    self.show_target_paths()

                elif choice == '3':
                    target_paths = self.get_target_paths()
                    expanded_paths = [os.path.expanduser(os.path.expandvars(p)) for p in target_paths]
                    self.path_utils.validate_paths(expanded_paths)

                elif choice == '4':
                    print("\n开始同步路径...")
                    success, total, skipped = self.sync_paths(dry_run=False)
                    if success > 0:
                        print("同步完成！建议重新启动终端以使更改生效。")

                elif choice == '5':
                    print("\n试运行模式（不实际修改系统）:")
                    self.sync_paths(dry_run=True)

                elif choice == '6':
                    custom_paths = input("请输入要添加的自定义路径（多个路径用分号分隔）: ").strip()
                    if custom_paths:
                        paths_list = [p.strip() for p in custom_paths.split(';') if p.strip()]
                        if paths_list:
                            self.add_custom_paths(set(paths_list))

                elif choice == '7':
                    print("再见！")
                    break

                else:
                    print("无效选择，请重新输入")

            except KeyboardInterrupt:
                print("\n\n操作被用户中断")
                break
            except Exception as e:
                print(f"发生错误: {e}")

def main():
    """命令行主函数"""
    if len(sys.argv) > 1 and sys.argv[1] == 'auto':
        # 自动模式：直接执行同步
        synchronizer = PathSynchronizer()
        success, total, skipped = synchronizer.sync_paths(dry_run=False)
        sys.exit(0 if success == total - skipped else 1)
    else:
        # 交互模式
        synchronizer = PathSynchronizer()
        synchronizer.interactive_sync()

if __name__ == "__main__":
    main()