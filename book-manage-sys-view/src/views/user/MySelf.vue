<template>
    <div class="container">
        <div class="container-top">
            <div class="return-page" @click="returnPage">
                <i class="el-icon-back"></i>
            </div>
            <div class="title">个人中心</div>
        </div>
        <div class="item">
            <span :style="{
                fontWeight: tagSelected === tagItem ? '800' : '',
                color: tagSelected === tagItem ? 'rgb(51,51,51)' : '',
                backgroundColor: tagSelected === tagItem ? 'rgb(247, 247, 247)' : ''
            }" @click="condition(tagItem)" v-for="(tagItem, index) in tags" :key="index">
                {{ tagItem }}
            </span>
        </div>
        <div v-if="tagSelected === '修改资料'">
            <Self />
        </div>
        <div v-else-if="tagSelected === '修改密码'">
            <ResetPwd />
        </div>
        <div v-else-if="tagSelected === '退出登录'">
            <el-result icon="warning" title="退出" subTitle="退出后将重新登录">
                <template slot="extra">
                    <span class="loginout" @click="loginout">我确定</span>
                </template>
            </el-result>
        </div>
    </div>
</template>

<script>
import ResetPwd from '@/views/user/ResetPwd'
import Self from '@/views/user/Self'
export default {
    components: { ResetPwd, Self },
    data() {
        return {
            tags: ['修改资料', '修改密码', '退出登录'],
            tagSelected: '',
            defaultPath: '修改资料',
        };
    },
    created() {
        this.condition(this.defaultPath);
    },
    methods: {
        loginout() {
            sessionStorage.setItem('token', null);
            this.$router.push('/login');
        },
        condition(tag) {
            this.tagSelected = tag;
        },
        returnPage() {
            this.$router.go(-1);
        },
    },
};
</script>
<style scoped lang="scss">
.loginout{
    display: inline-block;
    background-color: rgb(51,51,51);
    color: rgb(245,245,245);
    border-radius: 5px;
    padding: 4px 30px;
    cursor: pointer;
}
.loginout:hover{
    background-color: rgb(35, 35, 35);
}
.item {
    width: 800px;
    padding-block: 10px;
    margin-block: 20px;
    display: flex;
    justify-content: left;
    gap: 4px;

    span {
        font-size: 16px;
        cursor: pointer;
        display: inline-block;
        transition: all .2s;
        padding: 10px 20px;
        border-radius: 10px;
    }

    span:hover {
        background-color: rgb(246, 246, 246);
    }

}


.container {
    width: 800px;
    margin: 0 auto;
    padding: 40px 30px;

    .container-top {
        display: flex;
        justify-content: left;
        align-items: center;
        gap: 8px;

        .return-page {
            padding: 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        .return-page:hover {
            background-color: rgb(248, 248, 248);
        }

        .title {
            font-size: 30px;
            font-weight: 800;
        }
    }
}
</style>