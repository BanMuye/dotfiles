#!/usr/bin/env python3
"""
创建硬链接的脚本
Author: Assistant
Date: 2025-10-17
Version: 1.0
Description: 该脚本提供创建硬链接的功能，包含源文件检查、目标文件处理和链接验证
"""

import os
import sys

def create_hard_link(source_path, target_path):
    """
    创建从source_path到target_path的硬链接
    
    Args:
        source_path (str): 源文件路径
        target_path (str): 目标硬链接路径
        
    Returns:
        bool: 创建成功返回True，否则返回False
    """
    
    # 检查源文件是否存在且为文件[9,10](@ref)
    if not os.path.exists(source_path):
        print(f"错误：源文件 '{source_path}' 不存在")
        return False
        
    if not os.path.isfile(source_path):
        print(f"错误： '{source_path}' 不是文件")
        return False
    
    # 检查目标路径是否存在[9](@ref)
    if os.path.exists(target_path):
        if os.path.isfile(target_path):
            # 询问用户是否删除已存在的目标文件[12](@ref)
            response = input(f"目标文件 '{target_path}' 已存在，是否删除？(y/N): ").strip().lower()
            if response in ('y', 'yes'):
                try:
                    os.remove(target_path)
                    print(f"已删除现有文件: {target_path}")
                except OSError as e:
                    print(f"删除文件失败: {e}")
                    return False
            else:
                print("用户选择不删除文件，操作中止")
                return False
        else:
            print(f"错误： '{target_path}' 已存在但不是文件")
            return False
    
    # 创建硬链接[1,2](@ref)
    try:
        os.link(source_path, target_path)
        print(f"硬链接创建成功: {source_path} -> {target_path}")
    except OSError as e:
        print(f"创建硬链接失败: {e}")
        return False
    
    # 验证硬链接是否有效[1,3](@ref)
    if validate_hard_link(source_path, target_path):
        print("硬链接验证成功")
        return True
    else:
        print("硬链接验证失败")
        # 清理创建的不完整链接
        try:
            if os.path.exists(target_path):
                os.remove(target_path)
        except OSError:
            pass
        return False

def validate_hard_link(source_path, target_path):
    """
    验证硬链接是否创建成功
    
    Args:
        source_path (str): 源文件路径
        target_path (str): 目标硬链接路径
        
    Returns:
        bool: 验证成功返回True，否则返回False
    """
    try:
        # 检查目标文件是否存在[10](@ref)
        if not os.path.exists(target_path):
            print("验证失败：目标文件不存在")
            return False
        
        # 检查是否为文件[10](@ref)
        if not os.path.isfile(target_path):
            print("验证失败：目标路径不是文件")
            return False
        
        # 检查两个文件是否具有相同的inode（硬链接的核心特征）[1](@ref)
        source_stat = os.stat(source_path)
        target_stat = os.stat(target_path)
        
        # 在Unix系统上检查inode，在Windows上检查文件标识符[1](@ref)
        if hasattr(source_stat, 'st_ino') and hasattr(target_stat, 'st_ino'):
            if source_stat.st_ino == target_stat.st_ino:
                print("验证通过：源文件和目标文件具有相同的inode")
                return True
            else:
                print("验证失败：源文件和目标文件inode不同")
                return False
        else:
            # 在Windows等不支持inode的系统上，检查文件大小和修改时间等元数据
            if (source_stat.st_size == target_stat.st_size and 
                source_stat.st_mtime == target_stat.st_mtime):
                print("验证通过：文件元数据一致")
                return True
            else:
                print("验证失败：文件元数据不一致")
                return False
                
    except OSError as e:
        print(f"验证过程中发生错误: {e}")
        return False

if __name__ == "__main__":
    # 命令行直接测试使用
    if len(sys.argv) != 3:
        print("用法: python create_hard_link.py <源文件> <目标文件>")
        sys.exit(1)
    
    source = sys.argv[1]
    target = sys.argv[2]
    
    if create_hard_link(source, target):
        print("硬链接创建并验证成功")
        sys.exit(0)
    else:
        print("硬链接创建失败")
        sys.exit(1)