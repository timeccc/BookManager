
.avatar-uploader {
    border: 1px dashed #d9d9d9;
    border-radius: 8px; // 添加：头像框圆角效果
    cursor: pointer;
    position: relative;
    overflow: hidden;
    width: 100px;
    height: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    
    &:hover {
        border-color: #ff5722;
    }
    
    .avatar-image {
        width: 100%;
        height: 100%;
        object-fit: cover; // 确保头像填满方框
        display: block;
        margin: 0;
    }
    
    .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 100px;
        height: 100px;
        line-height: 100px;
        text-align: center;
    }
}

