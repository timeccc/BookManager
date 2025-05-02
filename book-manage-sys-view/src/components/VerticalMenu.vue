<template>
	<el-menu :collapse-transition="false" :collapse="flag" class="admin-menu"
		:default-active="currentRoute" :background-color="bag" text-color="#333" @select="handleSelect">
		<el-menu-item v-for="(item, index) in routes" :key="index" v-if="!item.isHidden" :index="item.path"
			:class="{ 'active-menu-item': isActive(item.path) }">
			<i :class="item.icon"></i>
			<span slot="title">{{ item.name }}</span>
		</el-menu-item>
	</el-menu>
</template>
<script>
export default {
	name: 'AdminMenu',
	data() {
		return {
			activeIndex: "1"
		}
	},
	computed: {
		currentRoute() {
			// 获取当前路由路径
			return this.$route.path;
		}
	},
	props: {
		routes: {
			type: Array,
			required: true
		},
		flag: {
			type: Boolean,
			required: true
		},
		bag: {
			type: String,
			default: 'transparent'
		}
	},
	created() {
		// 初始化时根据当前路由设置活动菜单项
		const currentPath = this.$route.path;
		this.activeIndex = currentPath;
		sessionStorage.setItem('activeMenuItem', this.activeIndex);
	},
	methods: {
		isActive(path) {
			// 判断当前路径是否为活动路径
			return this.$route.path === path;
		},
		handleSelect(index) {
			this.activeIndex = index;
			this.$emit('select', this.activeIndex);
			sessionStorage.setItem('activeMenuItem', this.activeIndex);
		},
	},
};
</script>

<style scoped lang="scss">
// 定义变量
$primary-color: #409EFF;
$secondary-color: #64B5F6;
$transition-bezier: cubic-bezier(0.34, 1.56, 0.64, 1);
$border-radius: 16px;
$shadow-normal: 0 6px 20px rgba(0, 0, 0, 0.06);
$shadow-active: 0 8px 24px rgba(64, 158, 255, 0.3);
$shadow-active-pulse: 0 10px 30px rgba(64, 158, 255, 0.5);

// 共用动画
@keyframes subtle-bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-2px); }
}

@keyframes pulseActive {
    0%, 100% { box-shadow: $shadow-active; }
    50% { box-shadow: $shadow-active-pulse; }
}

@keyframes menu-popup {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes menu-item-slide {
    to { opacity: 1; transform: translateX(0); }
}

// 基本菜单样式
.admin-menu {
    border-right: none;
    width: 100%;
    background-color: transparent;
    padding: 10px 12px 10px 16px;
    box-sizing: border-box;
    
    // 菜单项通用样式
    .el-menu-item {
        height: 50px;
        line-height: 50px;
        margin: 8px auto;
        border-radius: $border-radius;
        transition: all 0.4s $transition-bezier;
        font-size: 15px;
        padding: 0 18px;
        overflow: hidden;
        position: relative;
        width: calc(100% - 16px);
        margin-right: 16px;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        box-sizing: border-box;
        
        // 悬浮背景
        &::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: $border-radius;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.4s $transition-bezier;
            background: linear-gradient(135deg, rgba(235, 242, 255, 0.9), rgba(235, 242, 255, 0.7));
            transform: scale(0.96);
        }
        
        // 悬浮效果
        &:hover {
            background-color: transparent;
            color: $primary-color;
            box-shadow: $shadow-normal;
            transform: translateY(-2px);
            
            &::before {
                opacity: 1;
                transform: scale(1);
            }
            
            i {
                color: $primary-color;
                transform: scale(1.1) rotate(5deg);
            }
        }
        
        &:focus {
            background-color: transparent;
        }
        
        // 图标样式
        i {
            font-size: 18px;
            margin-right: 12px;
            color: #555;
            transition: all 0.4s $transition-bezier;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        // 文本样式
        span {
            font-weight: 500;
            color: #333;
            transition: all 0.3s ease;
            letter-spacing: 0.2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transform-origin: left center;
        }
    }
    
    // 激活状态样式
    .active-menu-item {
        background: linear-gradient(135deg, $primary-color, $secondary-color);
        color: white;
        font-weight: bold;
        box-shadow: $shadow-active;
        border-radius: $border-radius;
        transform: translateY(-2px);
        animation: pulseActive 2s infinite;
        
        &::before {
            opacity: 0;
        }
        
        i, span {
            color: white;
        }
        
        i {
            animation: subtle-bounce 2s infinite;
        }
    }
}

// 折叠状态样式
.el-menu--collapse {
    width: 90px;
    min-width: 90px;
    padding: 10px 8px;
    
    .el-menu-item {
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 50px;
        line-height: 50px;
        margin: 8px auto;
        border-radius: $border-radius;
        margin-left: auto;
        margin-right: auto;
        width: 60px;
        min-width: 60px;
        transition: all 0.4s $transition-bezier;
        
        i {
            margin: 0;
            font-size: 22px;
            position: static;
            transition: all 0.4s $transition-bezier;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: 100%;
        }
        
        span {
            display: none;
        }
        
        &:hover {
            transform: translateY(-2px) scale(1.05);
            
            i {
                transform: scale(1.15) rotate(5deg);
            }
        }
    }
    
    .active-menu-item {
        background: linear-gradient(135deg, $primary-color, $secondary-color);
        box-shadow: $shadow-active;
        animation: pulseActive 2s infinite;
        
        i {
            color: white;
            animation: subtle-bounce 2s infinite;
        }
    }
}

// 其他样式修复和增强
.el-menu-item.is-active {
    border-radius: $border-radius;
}

.el-menu--collapse .el-tooltip {
    padding: 0;
    width: 60px;
    min-width: 60px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.el-menu {
    transition: width 0.4s $transition-bezier, 
                padding 0.4s $transition-bezier, 
                min-width 0.4s $transition-bezier;
}

.el-menu-item-group__title {
    display: none;
}

// 弹出菜单动画
.el-menu--popup {
    min-width: 200px;
    border-radius: 8px;
    overflow: hidden;
    animation: menu-popup 0.3s $transition-bezier;
    
    .el-menu-item {
        height: 46px;
        line-height: 46px;
        margin: 4px 0;
        animation: menu-item-slide 0.3s ease forwards;
        opacity: 0;
        transform: translateX(-10px);
        
        @for $i from 1 through 10 {
            &:nth-child(#{$i}) {
                animation-delay: #{$i * 0.05}s;
            }
        }
    }
}

// 隐藏提示
.el-tooltip__popper {
    display: none;
}
</style>