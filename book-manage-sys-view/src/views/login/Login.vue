<template>
    <div class="login-container">
        <div style="display: flex;justify-content: left;margin: 20px 0;">
            <img src="/logo.jpg" style="width: 220px;height: 100px;">
        </div>
        <div class="login-panel">
            <div style="width: 300px;padding: 40px;display: flex;justify-content: center;align-items: center;">
                <img src="/bag.png" style="width: 350px;" />
            </div>
            <div class="right-login">
                <div>
                    <h2>快登录吧</h2>
                </div>
                <div class="text">
                    <input v-model="act" class="act" placeholder="输入账号" />
                </div>
                <div class="text">
                    <input v-model="pwd" class="pwd" type="password" placeholder="输入密码" />
                </div>
                <div>
                    <span class="login-btn" @click="login">立即登录</span>
                </div>
                <div class="tip">
                    <p>没有账号？<span class="no-act" @click="toDoRegister">点此注册</span></p>
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

.login-container {
    width: 100%;
    min-height: 100vh;
    background-color: rgb(255,255,255);
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;

    .login-panel {
        display: flex;
        border-top-left-radius: 10px;
        padding: 20px;
        justify-content: space-between;
        height: auto;
        border-radius: 6px;
        border-top-left-radius: 100px;
        border-bottom-left-radius: 20px;
        // background-color: rgb(100, 119, 224);
        background: linear-gradient(to right, rgb(7, 109, 219), rgb(119, 139, 220));
        //box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.06);

        .right-login {
            width: 283px;
            background-color: rgb(253, 253, 253);
            padding: 30px;
            border-radius: 5px;
            // border-top-left-radius: 150px;
            // border-bottom-left-radius: 5px;
            // border-top-right-radius: 5px;
            // border-bottom-right-radius: 5px;
        }

        .logo {
            margin: 10px 0 30px 0;
        }

        .act,
        .pwd {
            margin: 8px 0;
            height: 63px;
            line-height: 63px;
            width: 100%;
            font-size: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-weight: 800;
            padding: 0 8px;
            background-color: rgb(248, 248, 248);
            box-sizing: border-box;
            border: 2px solid rgb(248, 248, 248);
            border-radius: 6px;
            padding: 0 15px;
            margin-top: 13px;
        }

        .act:focus,
        .pwd:focus {
            outline: none;
            //border: 2px solid rgb(16, 170, 209);
            transition: 1.2s;
            background-color: rgb(244, 244, 244);
        }

        .role {
            display: inline-block;
            color: rgb(30, 102, 147);
            font-size: 14px;
            padding-right: 10px;
        }
    }
    .login-btn:hover{
        background-color: rgb(39, 106, 208);
    }
    .login-btn {
        display: inline-block;
        text-align: center;
        border-radius: 3px;
        margin-top: 20px;
        height: 43px;
        line-height: 43px;
        width: 100%;
        background-color: rgb(62, 124, 220);
        font-size: 14px !important;
        border: none;
        color: white;
        padding: 0 !important;
        cursor: pointer;
        user-select: none;
    }

    .tip {
        margin: 20px 0;

        p {
            padding: 3px 0;
            margin: 0;
            font-size: 14px;
            color: #647897;

            i {
                margin-right: 3px;
            }

            span {
                color: #3b3c3e;
                border-radius: 2px;
                margin: 0 6px;
            }

            .no-act:hover {
                color: #3e77c2;
                cursor: pointer;
            }

        }
    }

}
</style>
