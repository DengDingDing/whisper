#!/bin/bash
set -e

# 配置参数
ENV_NAME="whisper-env"
PYTHON_VERSION="3.9"

echo "1. 创建 conda 虚拟环境: $ENV_NAME"
conda create -y -n $ENV_NAME python=$PYTHON_VERSION

echo "2. 激活虚拟环境"
source $(conda info --base)/etc/profile.d/conda.sh
conda activate $ENV_NAME

echo "3. 安装 ffmpeg"
conda install -y -c conda-forge ffmpeg

echo "4. 升级 pip"
pip install --upgrade pip

echo "5. 安装 Whisper (GitHub 最新版)"
pip install git+https://github.com/openai/whisper.git

echo "6. 安装 torch (自动判断 CUDA/CPU)"
# 如果有NVIDIA显卡建议安装GPU版torch，否则安装CPU版
if command -v nvidia-smi &> /dev/null; then
    echo "检测到NVIDIA显卡，安装CUDA版 torch"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
else
    echo "未检测到NVIDIA显卡，安装CPU版 torch"
    pip install torch torchvision torchaudio
fi

echo "7. 测试 Whisper 安装"
whisper --help

echo "全部完成！你可以用如下命令开始转录："
echo "whisper yourfile.mp4 --language Japanese --model medium --output_format srt --device cpu"