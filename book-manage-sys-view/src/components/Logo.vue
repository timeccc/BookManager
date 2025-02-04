<template>
    <span class="logo">
        <el-image style="width: 30px; height: 30px" src="/logo.png" fit="fill"></el-image>
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
    flex-wrap: wrap;
    user-select: none;

    span {
        margin-left: 8px;
        color: #666;
        font-family: Impact, Haettenschweiler, 'Arial Narrow Bold', sans-serif;
    }
}
</style>