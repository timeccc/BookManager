<template>
    <div class="login-container">
        <!-- 背景动画元素 -->
        <div class="area">
            <ul class="circles">
                <li v-for="i in 10" :key="i"></li>
            </ul>
        </div>
        
        <!-- 登录面板 -->
        <div class="login-panel">
            <!-- 左侧图片 -->
            <div class="left-image">
                <img src="/bag.png" alt="装饰图" class="floating">
            </div>
            
            <!-- 右侧登录框 -->
            <div class="right-login">
                <div class="login-header">
                    <h2>欢迎登录</h2>
                    <p class="login-subtitle">图书管理系统</p>
                </div>
                
                <div class="input-group">
                    <div class="input-item">
                        <i class="icon-user"></i>
                        <input v-model="act" class="input-field" placeholder="请输入账号" />
                    </div>
                    <div class="input-item">
                        <i class="icon-lock"></i>
                        <input v-model="pwd" class="input-field" type="password" placeholder="请输入密码" />
                </div>
                </div>
                
                <div class="login-action">
                    <button class="login-btn pulse" @click="login">登录</button>
                </div>
                
                <div class="tip">
                    <p>没有账号？<span class="register-link" @click="toDoRegister">立即注册</span></p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
const DELAY_TIME = 1300;
import request from "@/utils/request.js";
import { setToken } from "@/utils/storage.js";
import md5 from 'js-md5';
import Logo from '@/components/Logo.vue';
export default {
    name: "Login",
    components: { Logo },
    data() {
        return {
            act: '',
            pwd: '',
            colorLogo: 'rgb(38,38,38)',
        }
    },
    methods: {
        // 跳转注册页面
        toDoRegister() {
            this.$router.push('/register');
        },
        async login() {
            if (!this.act || !this.pwd) {
                this.$swal.fire({
                    title: '填写校验',
                    text: '账号或密码不能为空',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                return;
            }
            const hashedPwd = md5(md5(this.pwd));
            const paramDTO = { userAccount: this.act, userPwd: hashedPwd };
            try {
                const { data } = await request.post(`user/login`, paramDTO);
                if (data.code !== 200) {
                    this.$swal.fire({
                        title: '登录失败',
                        text: data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: DELAY_TIME,
                    });
                    return;
                }
                setToken(data.data.token);
                // 根据角色延迟跳转
                setTimeout(() => {
                    const { role } = data.data;
                    this.navigateToRole(role);
                }, DELAY_TIME);
            } catch (error) {
                console.error('登录请求错误:', error);
                this.$message.error('登录请求出错，请重试！');
            }
        },
        navigateToRole(role) {
            switch (role) {
                case 1:
                    this.$router.push('/admin');
                    break;
                case 2:
                    this.$router.push('/user');
                    break;
                default:
                    console.warn('未知的角色类型:', role);
                    break;
            }
        },
    }
};
</script>

<style lang="scss" scoped>
* {
    user-select: none;
}

@keyframes float {
    0% {
        transform: translateY(0px) scale(1.1);
    }
    50% {
        transform: translateY(-20px) scale(1.15);
    }
    100% {
        transform: translateY(0px) scale(1.1);
    }
}

@keyframes pulse {
    0% {
        box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4);
    }
    70% {
        box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
    }
    100% {
        box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
    }
}

@keyframes animate {
    0% {
        transform: translateY(0) rotate(0deg);
        opacity: 1;
        border-radius: 0;
    }
    100% {
        transform: translateY(-1000px) rotate(720deg);
        opacity: 0;
        border-radius: 50%;
    }
}

.login-container {
    width: 100%;
    min-height: 100vh;
    background: linear-gradient(to right, #ff9a9e, #fad0c4, #fad0c4, #a1c4fd);
    background-size: 300% 300%;
    animation: gradientBG 15s ease infinite;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    position: relative;
    overflow: hidden;
}

@keyframes gradientBG {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.area {
    position: absolute;
    width: 100%;
    height: 100vh;
    z-index: 1;
}

.circles {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    margin: 0;
    padding: 0;
}

.circles li {
    position: absolute;
    display: block;
    list-style: none;
    width: 20px;
    height: 20px;
    background: rgba(255, 255, 255, 0.2);
    animation: animate 25s linear infinite;
    bottom: -150px;
}

.circles li:nth-child(1) {
    left: 25%;
    width: 80px;
    height: 80px;
    animation-delay: 0s;
    animation-duration: 20s;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 50%;
}

.circles li:nth-child(2) {
    left: 10%;
    width: 20px;
    height: 20px;
    animation-delay: 2s;
    animation-duration: 12s;
    background: rgba(255, 182, 193, 0.3);
    border-radius: 30%;
}

.circles li:nth-child(3) {
    left: 70%;
    width: 25px;
    height: 25px;
    animation-delay: 4s;
    animation-duration: 15s;
    background: rgba(173, 216, 230, 0.3);
    border-radius: 40%;
}

.circles li:nth-child(4) {
    left: 40%;
    width: 60px;
    height: 60px;
    animation-delay: 0s;
    animation-duration: 18s;
    background: rgba(240, 248, 255, 0.4);
    border-radius: 60%;
}

.circles li:nth-child(5) {
    left: 65%;
    width: 20px;
    height: 20px;
    animation-delay: 0s;
    animation-duration: 14s;
    background: rgba(135, 206, 250, 0.3);
    border-radius: 40%;
}

.circles li:nth-child(6) {
    left: 75%;
    width: 110px;
    height: 110px;
    animation-delay: 3s;
    animation-duration: 25s;
    background: rgba(255, 192, 203, 0.2);
    border-radius: 40%;
}

.circles li:nth-child(7) {
    left: 35%;
    width: 150px;
    height: 150px;
    animation-delay: 7s;
    animation-duration: 30s;
    background: rgba(176, 224, 230, 0.2);
    border-radius: 50%;
}

.circles li:nth-child(8) {
    left: 50%;
    width: 25px;
    height: 25px;
    animation-delay: 15s;
    animation-duration: 45s;
    background: rgba(240, 248, 255, 0.3);
    border-radius: 50%;
}

.circles li:nth-child(9) {
    left: 20%;
    width: 15px;
    height: 15px;
    animation-delay: 2s;
    animation-duration: 35s;
    background: rgba(255, 192, 203, 0.3);
    border-radius: 60%;
}

.circles li:nth-child(10) {
    left: 85%;
    width: 150px;
    height: 150px;
    animation-delay: 0s;
    animation-duration: 11s;
    background: rgba(176, 224, 230, 0.2);
    border-radius: 40%;
}

    .login-panel {
        display: flex;
    border-radius: 24px;
    width: 840px;
    height: auto;
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.2);
    overflow: hidden;
    transition: all 0.5s ease;
    z-index: 2;
    
    &:hover {
        box-shadow: 0 15px 35px rgba(31, 38, 135, 0.25);
        transform: translateY(-5px);
    }
    
    .left-image {
        width: 50%;
        padding: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(135deg, rgba(161, 196, 253, 0.7), rgba(194, 233, 251, 0.7));
        overflow: hidden;
        border-radius: 20px 0 0 20px;
        
        img.floating {
            width: 100%;
        height: auto;
            max-width: 350px;
            object-fit: contain;
            animation: float 6s ease-in-out infinite;
            filter: drop-shadow(0 10px 15px rgba(0, 0, 0, 0.15));
        }
    }

        .right-login {
        width: 50%;
        padding: 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 0 20px 20px 0;
    }
    
    .login-header {
        margin-bottom: 30px;
        text-align: center;
        
        h2 {
            color: #fff;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            letter-spacing: 1px;
        }
        
        .login-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 16px;
            letter-spacing: 0.5px;
        }
        }

    .input-group {
        margin-bottom: 25px;
        }

    .input-item {
        position: relative;
        margin-bottom: 20px;
        
        .icon-user, .icon-lock {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.8);
            font-size: 18px;
            z-index: 1;
            &:before {
                font-family: "element-icons";
            }
        }
        
        .icon-user:before {
            content: "\e7ae";
        }
        
        .icon-lock:before {
            content: "\e709";
        }
    }
    
    .input-field {
        width: 100%;
        height: 55px;
        border-radius: 16px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        background-color: rgba(255, 255, 255, 0.1);
        padding: 0 20px 0 50px;
        font-size: 16px;
        transition: all 0.3s ease;
        box-sizing: border-box;
        color: white;
        
        &:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.8);
            background-color: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
        }

        &::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }
    }
    
    .login-action {
        margin-top: 15px;
    }
    
    .login-btn {
        width: 100%;
        height: 55px;
        border-radius: 16px;
        background: linear-gradient(to right, #a18cd1, #fbc2eb);
        color: white;
        font-size: 18px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: all 0.4s ease;
        letter-spacing: 1px;
        position: relative;
        overflow: hidden;
        
        &:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: 0.5s;
        }
        
        &:hover {
            background: linear-gradient(to right, #8e78c9, #f9aee5);
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(161, 196, 253, 0.4);
            
            &:before {
                left: 100%;
            }
        }
        
        &:active {
            transform: translateY(0);
        }
        
        &.pulse {
            animation: pulse 2s infinite;
        }
    }

    .tip {
        margin-top: 30px;
        text-align: center;
        
        p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 15px;
            
            .register-link {
                color: #ffffff;
                margin-left: 5px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                position: relative;
                padding-bottom: 2px;
                
                &:after {
                    content: '';
                    position: absolute;
                    width: 0;
                    height: 2px;
                    bottom: 0;
                    left: 0;
                    background-color: white;
                    transition: width 0.3s ease;
                }
                
                &:hover {
                    text-shadow: 0 0 5px rgba(255, 255, 255, 0.8);
                    
                    &:after {
                        width: 100%;
                    }
                }
            }
        }
    }
}

/* 响应式设计 */
@media screen and (max-width: 850px) {
    .login-panel {
        width: 90%;
        flex-direction: column;
        
        .left-image, .right-login {
            width: 100%;
            border-radius: 20px;
        }
        
        .left-image {
            padding: 30px;
            height: 200px;
            }

        .right-login {
            padding: 30px;
        }
    }
}
</style>
