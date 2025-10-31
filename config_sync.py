#!/usr/bin/env python3
"""
Vim配置文件安装脚本
Author: Assistant  
Date: 2025-10-17
Version: 1.0
Description: 该脚本用于创建Vim配置文件的硬链接，将当前目录的.vimrc链接到用户home目录
"""

import os
import sys

# 导入之前创建的硬链接函数
from create_hard_link import create_hard_link

def get_home_dir():
    """
    获取用户home目录
    
    Returns:
        str: 用户home目录路径
    """
    # 跨平台获取home目录[12](@ref)
    return os.path.expanduser('~')

def create_vim_config_links():
    """
    创建Vim配置文件的硬链接
    """
    # 获取当前脚本所在目录
    current_dir = os.getcwd()
    home_dir = get_home_dir()
    
    # 定义源文件到目标文件的映射[12](@ref)
    config_map = {
        # 当前目录下的.vimrc文件 -> home目录下的多个配置文件
        os.path.join(current_dir, '.vimrc'): [
            os.path.join(home_dir, '.vimrc'),
            os.path.join(home_dir, '.ideavimrc')
        ]
    }
    
    print("开始创建Vim配置文件硬链接...")
    print(f"当前目录: {current_dir}")
    print(f"Home目录: {home_dir}")
    print("-" * 50)
    
    success_count = 0
    total_count = 0
    
    # 遍历映射，为每个源文件到目标文件创建硬链接[4](@ref)
    for source_path, target_paths in config_map.items():
        # 检查源文件是否存在[9](@ref)
        if not os.path.exists(source_path):
            print(f"警告：源文件 '{source_path}' 不存在，跳过")
            continue
            
        for target_path in target_paths:
            total_count += 1
            print(f"处理: {source_path} -> {target_path}")
            
            # 确保目标目录存在[12](@ref)
            target_dir = os.path.dirname(target_path)
            if not os.path.exists(target_dir):
                try:
                    os.makedirs(target_dir, exist_ok=True)
                    print(f"创建目录: {target_dir}")
                except OSError as e:
                    print(f"创建目录失败: {e}")
                    continue
            
            # 调用create_hard_link函数创建硬链接
            if create_hard_link(source_path, target_path):
                success_count += 1
            print("-" * 30)
    
    # 输出结果摘要
    print("=" * 50)
    print(f"操作完成: 成功 {success_count}/{total_count}")
    
    if success_count == total_count:
        print("所有硬链接创建成功！")
        return True
    else:
        print("部分硬链接创建失败，请检查上述错误信息")
        return False

def main():
    """
    主函数
    """
    print("Vim配置文件安装工具")
    print("=" * 50)
    
    # 检查当前目录是否存在.vimrc文件[9](@ref)
    vimrc_path = os.path.join(os.getcwd(), '.vimrc')
    if not os.path.exists(vimrc_path):
        print(f"警告：当前目录下未找到 .vimrc 文件")
        print(f"请确保在包含 .vimrc 文件的目录中运行此脚本")
        
        # 询问是否继续
        response = input("是否继续？(y/N): ").strip().lower()
        if response not in ('y', 'yes'):
            print("操作已取消")
            return False
    
    # 执行创建操作
    if create_vim_config_links():
        print("\n安装完成！现在您可以享受统一的Vim配置了。")
        return True
    else:
        print("\n安装过程中出现问题，请检查上述错误信息。")
        return False

if __name__ == "__main__":
    if main():
        sys.exit(0)
    else:
        sys.exit(1)