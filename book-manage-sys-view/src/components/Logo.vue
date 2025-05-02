<template>
    <div class="logo-container" :class="{'logo-collapsed': flag}">
        <img src="/logo.png" class="logo-image" alt="Logo">
        <span v-if="!flag" class="logo-text" :style="{ color: bag }">{{ name }}</span>
    </div>
</template>

<script>
export default {
    name: "Logo",
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
        }
    }
};
</script>

<style scoped lang="scss">
.logo-container {
    display: flex;
    align-items: center;
    padding: 0 16px;
    height: 100%;
    transition: all 0.3s ease;
    
    .logo-image {
        width: 42px;
        height: 42px;
        object-fit: contain;
        transition: all 0.3s ease;
        filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.15));
    }
    
    .logo-text {
        margin-left: 12px;
        font-family: "汉仪晓波花月圆", "Microsoft YaHei", sans-serif;
        font-weight: 600;
        font-size: 19px;
        letter-spacing: 0.5px;
        white-space: nowrap;
        overflow: hidden;
        transition: all 0.3s ease;
    }
}

.logo-collapsed {
    justify-content: center;
    padding: 0;
    
    .logo-image {
        width: 48px;
        height: 48px;
        margin: 0;
    }
}
</style>