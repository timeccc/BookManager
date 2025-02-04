<template>
    <div class="register-containel">
        <div class="register-panel">
            <div class="logo">
                <Logo name="我要注册"/>
            </div>
            <div class="text">
                <input v-model="act" class="act" placeholder="注册账号" />
            </div>
            <div class="text">
                <input v-model="name" class="act" placeholder="用户名" />
            </div>
            <div class="text">
                <input v-model="pwd" class="pwd" type="password" placeholder="输入密码" />
            </div>
            <div class="text">
                <input v-model="pwdConfirm" class="pwd" type="password" placeholder="输入密码" />
            </div>
            <div>
                <span class="register-btn" @click="registerFunc">立即注册</span>
            </div>
            <div class="tip">
                <p>已有账户？<span class="no-act" @click="toDoLogin">返回登录</span></p>
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
* {
    user-select: none;
}

.register-containel {
    // background-image: url('/bag.png');
    width: 100%;
    min-height: 100vh;
   // background-color: rgb(207, 192, 109);
    display: flex;
    /* 启用Flexbox布局 */
    justify-content: center;
    /* 水平居中 */
    align-items: center;
    /* 垂直居中 */
    flex-direction: column;
    /* 如果需要垂直居中，确保子元素也是这样排列 */

    .register-panel {
        margin: 0 auto;
        width: 293px;
        height: auto;
        padding: 40px 30px 16px 30px;
        border-radius: 10px;
        background-color: rgb(255,255,255);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.06);

        .logo {
            margin: 10px 0 30px 0;
        }

        .act,
        .pwd {
            margin: 8px 0;
            height: 53px;
            line-height: 53px;
            width: 100%;
            padding: 0 8px;
            background-color: rgb(251,251,251);
            box-sizing: border-box;
            border: 1px solid rgb(251,251,251);
            border-radius: 5px;
            font-weight: 800;
            font-size: 18px;
            padding: 0 15px;
            margin-top: 13px;
        }

        .act:focus,
        .pwd:focus {
            outline: none;
            background-color: rgb(242,243,244);
            transition: 1.2s;
        }

        .role {
            display: inline-block;
            color: rgb(30, 102, 147);
            font-size: 14px;
            padding-right: 10px;
        }
    }

    .register-btn {
        display: inline-block;
        text-align: center;
        border-radius: 3px;
        margin-top: 20px;
        height: 43px;
        line-height: 43px;
        width: 100%;
        background-color: rgb(101, 103, 193);
        font-size: 14px !important;
        border: none;
        color: rgb(250,250,250);
        padding: 0 !important;
        cursor: pointer;
        user-select: none;
    }

    .tip {
        margin: 20px 0;

        p {
            padding: 3px 0;
            font-size: 14px;
            margin: 0;
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
                color: #568ed7;
                cursor: pointer;
            }

        }
    }

}
</style>
