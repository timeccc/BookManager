<template>
    <div class="login-container" ref="container">
        <!-- 背景动态粒子 -->
        <div class="particles-container">
            <div class="particle" v-for="i in 30" :key="i"></div>
        </div>
        
        <!-- 动态光晕效果 -->
        <div class="light-effect light-1"></div>
        <div class="light-effect light-2"></div>
        
        <!-- 登录面板 -->
        <div class="login-panel" ref="loginPanel">
            <!-- 左侧图片 -->
            <div class="left-image">
                <img src="/bag.png" alt="装饰图" class="floating">
                <div class="logo-overlay">
                    <div class="logo-text">Book</div>
                </div>
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
                        <span class="input-focus-border"></span>
                    </div>
                    <div class="input-item">
                        <i class="icon-lock"></i>
                        <input v-model="pwd" class="input-field" type="password" placeholder="请输入密码" />
                        <span class="input-focus-border"></span>
                    </div>
                </div>
                
                <div class="login-action">
                    <button class="login-btn" @click="login">
                        <span>登录</span>
                        <i class="btn-icon">→</i>
                    </button>
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
    mounted() {
        // 添加鼠标移动互动效果
        this.addMouseInteraction();
    },
    methods: {
        // 跳转注册页面
        toDoRegister() {
            this.$router.push('/register');
        },
        // 添加鼠标互动
        addMouseInteraction() {
            const container = this.$refs.container;
            const loginPanel = this.$refs.loginPanel;
            
            if (!container || !loginPanel) return;
            
            container.addEventListener('mousemove', (e) => {
                const x = e.clientX / window.innerWidth;
                const y = e.clientY / window.innerHeight;
                
                // 面板轻微倾斜效果
                loginPanel.style.transform = `
                    translateY(-5px)
                    perspective(1000px)
                    rotateX(${(y - 0.5) * 5}deg) 
                    rotateY(${(x - 0.5) * -5}deg)
                `;
                
                // 光晕移动效果
                document.querySelector('.light-1').style.transform = `translate(${x * 30}px, ${y * 30}px)`;
                document.querySelector('.light-2').style.transform = `translate(${-x * 20}px, ${-y * 20}px)`;
            });
            
            // 鼠标离开时恢复原状
            container.addEventListener('mouseleave', () => {
                loginPanel.style.transform = 'translateY(-5px)';
            });
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
/* 引入造字工房舒雅体字体 */
@font-face {
    font-family: '造字工房舒雅体（非商用）','PingFang SC', sans-serif;
    src: url('/fonts/MZFShuYaTi.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
    font-display: swap;
}

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

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes gradient {
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

@keyframes float-particle {
    0% {
        transform: translateY(0) translateX(0);
    }
    50% {
        transform: translateY(-30px) translateX(15px);
    }
    100% {
        transform: translateY(0) translateX(0);
    }
}

@keyframes pulse-light {
    0% {
        opacity: 0.4;
        transform: scale(0.8);
    }
    50% {
        opacity: 0.7;
        transform: scale(1.2);
    }
    100% {
        opacity: 0.4;
        transform: scale(0.8);
    }
}

.login-container {
    width: 100%;
    min-height: 100vh;
    background: linear-gradient(135deg, #ff9a9e, #fbc2eb, #a1c4fd, #c2e9fb);
    background-size: 300% 300%;
    animation: gradient 15s ease infinite;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    position: relative;
    overflow: hidden;
    perspective: 1000px;
}

.particles-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
    overflow: hidden;
}

.particle {
    position: absolute;
    background: rgba(255, 255, 255, 0.4);
    border-radius: 50%;
    width: 10px;
    height: 10px;
    animation: float-particle 15s infinite;
    animation-delay: var(--delay);
    animation-duration: var(--duration);
    opacity: var(--opacity);
    z-index: 1;
}

.particle:nth-child(3n) {
    --size: 15px;
    width: var(--size);
    height: var(--size);
    --delay: 2s;
    --duration: 20s;
    --opacity: 0.2;
    top: 20%;
    left: 80%;
    backdrop-filter: blur(1px);
    background: rgba(255, 255, 255, 0.2);
    box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
}

.particle:nth-child(3n+1) {
    --size: 20px;
    width: var(--size);
    height: var(--size);
    --delay: 5s;
    --duration: 25s;
    --opacity: 0.15;
    top: 70%;
    left: 30%;
    backdrop-filter: blur(1px);
    background: rgba(255, 255, 255, 0.3);
    box-shadow: 0 0 15px rgba(255, 255, 255, 0.4);
}

.particle:nth-child(3n+2) {
    --size: 8px;
    width: var(--size);
    height: var(--size);
    --delay: 0s;
    --duration: 30s;
    --opacity: 0.3;
    top: 40%;
    left: 60%;
    backdrop-filter: blur(1px);
    background: rgba(255, 255, 255, 0.4);
    box-shadow: 0 0 8px rgba(255, 255, 255, 0.6);
}

.light-effect {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    z-index: 0;
    opacity: 0.5;
    animation: pulse-light 10s infinite alternate;
    transition: transform 0.5s ease;
}

.light-1 {
    width: 300px;
    height: 300px;
    background: rgba(253, 200, 231, 0.5);
    top: 20%;
    left: 30%;
    animation-delay: 0s;
}

.light-2 {
    width: 400px;
    height: 400px;
    background: rgba(161, 196, 253, 0.5);
    bottom: 10%;
    right: 20%;
    animation-delay: 2s;
}

.login-panel {
    display: flex;
    border-radius: 24px;
    width: 840px;
    height: 500px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 
        0 15px 35px rgba(31, 38, 135, 0.2),
        0 8px 16px rgba(0, 0, 0, 0.05),
        inset 0 0 0 1px rgba(255, 255, 255, 0.2);
    overflow: hidden;
    transition: all 0.5s cubic-bezier(0.23, 1, 0.32, 1);
    animation: fadeIn 0.8s ease-out forwards;
    z-index: 10;
    position: relative;
    will-change: transform;
    transform-style: preserve-3d;
    
    &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(
            135deg,
            rgba(255, 255, 255, 0.2) 0%,
            rgba(255, 255, 255, 0) 100%
        );
        z-index: -1;
    }
    
    &::after {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(
            circle at center,
            rgba(255, 255, 255, 0.1) 0%,
            rgba(255, 255, 255, 0) 70%
        );
        opacity: 0.2;
        z-index: -1;
        pointer-events: none;
    }
    
    .left-image {
        width: 50%;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(135deg, rgba(161, 196, 253, 0.8), rgba(194, 233, 251, 0.8));
        overflow: hidden;
        border-radius: 24px 0 0 24px;
        position: relative;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.3);
        
        &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
                45deg,
                rgba(255, 255, 255, 0.1) 0%,
                rgba(255, 255, 255, 0.05) 100%
            );
            z-index: 1;
        }
        
        img.floating {
            width: 100%;
            height: auto;
            max-width: 350px;
            object-fit: contain;
            animation: float 6s ease-in-out infinite;
            filter: drop-shadow(0 10px 15px rgba(0, 0, 0, 0.15));
            z-index: 2;
        }
        
        .logo-overlay {
            position: absolute;
            top: 30px;
            left: 30px;
            z-index: 3;
            
            .logo-text {
                font-size: 24px;
                font-weight: 800;
                color: white;
                text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                letter-spacing: 1px;
            }
        }
    }

    .right-login {
        width: 50%;
        padding: 50px 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background: rgba(255, 255, 255, 0.03);
        border-radius: 0 24px 24px 0;
        position: relative;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2);
        
        &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
                -45deg,
                rgba(255, 255, 255, 0.03) 0%,
                rgba(255, 255, 255, 0.06) 100%
            );
            z-index: -1;
        }
    }
    
    .login-header {
        margin-bottom: 30px;
        text-align: center;
        
        h2 {
            color: #fff;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            letter-spacing: 2px;
        }
        
        .login-subtitle {
            color: rgba(255, 255, 255, 1);
            font-size: 16px;
            letter-spacing: 1px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            font-family: '造字工房舒雅体（非商用）','PingFang SC', sans-serif;
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
            color: rgba(255, 255, 255, 0.9);
            font-size: 18px;
            z-index: 1;
            transition: all 0.3s ease;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
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
        
        .input-focus-border {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(to right, #a18cd1, #fbc2eb);
            transition: width 0.3s ease;
        }
    }
    
    .input-field {
        width: 100%;
        height: 52px;
        border-radius: 16px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        background-color: rgba(255, 255, 255, 0.08);
        padding: 0 20px 0 50px;
        font-size: 16px;
        transition: all 0.3s ease;
        box-sizing: border-box;
        color: white;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        
        &:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.8);
            background-color: rgba(255, 255, 255, 0.12);
            box-shadow: 0 5px 15px rgba(161, 196, 253, 0.2);
            
            & + .input-focus-border {
                width: 100%;
            }
            
            & ~ .icon-user, & ~ .icon-lock {
                color: white;
                text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
            }
        }

        &::placeholder {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 300;
        }
    }
    
    .login-action {
        margin-top: 10px;
    }
    
    .login-btn {
        width: 100%;
        height: 52px;
        border-radius: 16px;
        background: linear-gradient(45deg, #a18cd1, #fbc2eb);
        color: white;
        font-size: 18px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: all 0.4s ease;
        letter-spacing: 1px;
        position: relative;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 15px rgba(161, 140, 209, 0.4);
        
        span {
            margin-right: 10px;
            position: relative;
            z-index: 2;
        }
        
        .btn-icon {
            font-size: 20px;
            position: relative;
            z-index: 2;
            transition: transform 0.3s ease;
        }
        
        &:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #8e78c9, #f9aee5);
            opacity: 0;
            transition: opacity 0.4s ease;
        }
        
        &:hover {
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(161, 196, 253, 0.4);
            
            &:before {
                opacity: 1;
            }
            
            .btn-icon {
                transform: translateX(5px);
            }
        }
        
        &:active {
            transform: translateY(0);
        }
    }

    .tip {
        margin-top: 25px;
        text-align: center;
        
        p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 15px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            
            .register-link {
                color: #ffffff;
                margin-left: 5px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                position: relative;
                padding-bottom: 2px;
                text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
                
                &:after {
                    content: '';
                    position: absolute;
                    width: 0;
                    height: 2px;
                    bottom: 0;
                    left: 0;
                    background: linear-gradient(to right, #a18cd1, #fbc2eb);
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
@media screen and (max-width: 880px) {
    .login-panel {
        width: 90%;
        height: auto;
        flex-direction: column;
        
        .left-image, .right-login {
            width: 100%;
            border-radius: 24px;
        }
        
        .left-image {
            padding: 40px 0;
            height: 200px;
        }

        .right-login {
            padding: 30px;
        }
    }
    
    .light-effect {
        opacity: 0.3;
    }
}

@media screen and (max-width: 480px) {
    .login-panel {
        .right-login {
            padding: 25px 20px;
        }
        
        .login-header h2 {
            font-size: 26px;
        }
        
        .input-field {
            height: 48px;
        }
        
        .login-btn {
            height: 48px;
        }
    }
}
</style>

