<template>
    <span class="logo">
        <el-image style="width: 34px; height: 34px; margin-right: 5px" src="/logo.png" fit="fill"></el-image>
        <div v-if="!flag">
            <span :style="{ color: bag, display: 'block' }">{{ name }}</span>
        </div>
    </span>
</template>
<script>
export default {
    name: "Logo",
    data() {
        return {

        }
    },
    props: {
        name:{
            type: String,
            default: '系统'
        },
        flag: {
            type: Boolean,
            required: false
        },
        bag: {
            type: String,
            default: '#1c1c1c'
        },
    },
    created() {

    },
    methods: {

    }
};
</script>
<style scoped lang="scss">
.logo {
    color: rgb(8, 24, 16) !important;
    font-weight: bold;
    font-size: 26px;
    display: flex;
    align-items: center;
    flex-wrap: nowrap;
    user-select: none;

    span {
        margin-left: 10px;
        color: #333;
        font-family: "汉仪晓波花月圆", Arial, sans-serif;
        font-weight: 700;
        font-size: 22px;
        letter-spacing: 1px;
        text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
    }
}
</style>