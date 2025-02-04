<template>
    <div>
        <span style="margin-right: 20px;cursor: pointer;" @click="all">
            全部
        </span>
        <span v-for="(entity, index) in dataList" :key="index">
            <span class="tag-item"
                :style="{ backgroundColor: entity.isCheck ? 'rgb(56, 183, 129)' : 'rgb(252, 252, 252)', color: entity.isCheck ? '#FFFFFF' : '#1c1c1c' }"
                @click="onClick(entity)">
                {{ entity.name }}
            </span>
        </span>
    </div>
</template>

<script>
// 标签渲染组件，接收渲染参数，点击后会向父组件反馈
export default {
    name: "TagLine",
    props: {
        dataList: {
            type: Array,
            required: true
        }
    },
    methods: {
        onClick(tag) {
            this.$emit('on-click', tag);
        },
        all() {
            this.$emit('on-click', { id: null, name: '全部' });
        },
    }
};
</script>

<style scoped lang="scss">
.tag-item {
    font-size: 14px;
    display: inline-block;
    padding: 5px 14px 5px 0;
    margin: 25px 20px 25px 0;
    cursor: pointer;
    user-select: none;
    border-radius: 3px;
    transition: all 0.2s;
}
</style>