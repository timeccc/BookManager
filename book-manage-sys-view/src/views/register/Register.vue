<template>
    <div class="register-container">
        <!-- 注册面板 -->
        <div class="register-panel">
            <div class="register-header">
                <div class="logo-text">Book</div>
                <h2>用户注册</h2>
                <p class="register-subtitle">图书管理系统</p>
            </div>
            
            <div class="input-group">
                <div class="input-item">
                    <i class="icon-user"></i>
                    <input v-model="act" class="input-field" placeholder="请输入账号" />
                    <span class="input-focus-border"></span>
                </div>
                <div class="input-item">
                    <i class="icon-profile"></i>
                    <input v-model="name" class="input-field" placeholder="请输入用户名" />
                    <span class="input-focus-border"></span>
            </div>
                <div class="input-item">
                    <i class="icon-lock"></i>
                    <input v-model="pwd" class="input-field" type="password" placeholder="请输入密码" />
                    <span class="input-focus-border"></span>
            </div>
                <div class="input-item">
                    <i class="icon-lock"></i>
                    <input v-model="pwdConfirm" class="input-field" type="password" placeholder="请确认密码" />
                    <span class="input-focus-border"></span>
            </div>
            </div>
            
            <div class="register-action">
                <button class="register-btn" @click="registerFunc">
                    <span>立即注册</span>
                    <i class="btn-icon">→</i>
                </button>
            </div>
            
            <div class="tip">
                <p>已有账户？<span class="login-link" @click="toDoLogin">返回登录</span></p>
            </div>
        </div>
    </div>
</template>

<script>
const DELAY_TIME = 1300;
import request from "@/utils/request.js";
import md5 from 'js-md5';
import Logo from '@/components/Logo.vue';
export default {
    name: "Register",
    components: { Logo },
    data() {
        return {
            act: '', // 账号
            pwd: '', // 密码
            pwdConfirm: '', // 确认密码
            name: '' // 用户名
        }
    },
    methods: {
        // 返回登录页面
        toDoLogin() {
            this.$router.push('/login');
        },
        async registerFunc() {
            if (!this.act || !this.pwd || !this.pwdConfirm || !this.name ) {
                this.$swal.fire({
                    title: '填写校验',
                    text: '账号或密码或用户名不能为空',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                return;
            }
            if (this.pwd !== this.pwdConfirm) {
                this.$swal.fire({
                    title: '填写校验',
                    text: '前后密码输入不一致',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                return;
            }
            const hashedPwd = md5(md5(this.pwd));
            const paramDTO = { userAccount: this.act, userPwd: hashedPwd, userName: this.name };
            try {
                const { data } = await request.post(`user/register`, paramDTO);
                if (data.code !== 200) {
                    this.$swal.fire({
                        title: '注册失败',
                        text: data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: DELAY_TIME,
                    });
                    return;
                }
                // 使用Swal通知注册成功，延迟后跳转
                this.$swal.fire({
                    title: '注册成功',
                    text: '即将返回登录页...',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                // 根据角色延迟跳转
                setTimeout(() => {
                    this.$router.push('/login');
                }, DELAY_TIME);
            } catch (error) {
                console.error('注册请求错误:', error);
            }
        }
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
        transform: translateY(0px);
    }
    50% {
        transform: translateY(-10px);
    }
    100% {
        transform: translateY(0px);
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

.register-container {
    width: 100%;
    min-height: 100vh;
    background: linear-gradient(135deg, #ff9a9e, #fbc2eb, #a1c4fd, #c2e9fb);
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    position: relative;
    overflow: hidden;
}

    .register-panel {
    width: 450px;
    padding: 40px;
    border-radius: 24px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 15px 35px rgba(31, 38, 135, 0.2);
    z-index: 2;
    transition: all 0.5s ease;
    animation: fadeIn 0.8s ease-out forwards;
    
    &:hover {
        box-shadow: 0 20px 40px rgba(31, 38, 135, 0.3);
        transform: translateY(-5px);
        }

    .register-header {
        margin-bottom: 25px;
        text-align: center;
        position: relative;
        
        .logo-text {
            font-size: 24px;
            font-weight: 800;
            color: white;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            letter-spacing: 1px;
            margin-bottom: 10px;
        }
        
        h2 {
            color: #fff;
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            letter-spacing: 2px;
            animation: float 3s ease-in-out infinite;
        }
        
        .register-subtitle {
            color: rgba(255, 255, 255, 1);
            font-size: 16px;
            letter-spacing: 1px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            font-family: '造字工房舒雅体（非商用）','PingFang SC', sans-serif;
        }
    }
    
    .input-group {
        margin-bottom: 20px;
    }
    
    .input-item {
        position: relative;
        margin-bottom: 16px;
        
        .icon-user, .icon-profile, .icon-lock {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.9);
            font-size: 20px;
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
        
        .icon-profile:before {
            content: "\e7a5";
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
        border-radius: 18px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        background-color: rgba(255, 255, 255, 0.1);
        padding: 0 20px 0 55px;
        font-size: 16px;
        transition: all 0.3s ease;
        box-sizing: border-box;
        color: white;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        
        &:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.8);
            background-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 5px 15px rgba(161, 196, 253, 0.2);
            
            & + .input-focus-border {
                width: 100%;
            }
            
            & ~ .icon-user, & ~ .icon-profile, & ~ .icon-lock {
                color: white;
                text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
            }
        }

        &::placeholder {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 300;
        }
    }
    
    .register-action {
        margin-top: 10px;
    }

    .register-btn {
        width: 100%;
        height: 52px;
        border-radius: 18px;
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
        
        span {
            margin-right: 10px;
            position: relative;
            z-index: 2;
        }
        
        .btn-icon {
            font-size: 22px;
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
            
            .login-link {
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
@media screen and (max-width: 500px) {
    .register-panel {
        width: 90%;
        padding: 30px 25px;
    }
}

@media screen and (max-width: 400px) {
    .register-panel {
        padding: 25px 20px;
        
        .register-header h2 {
            font-size: 26px;
        }
        
        .input-field {
            height: 50px;
            padding: 0 15px 0 50px;
        }
    }
}
</style>
