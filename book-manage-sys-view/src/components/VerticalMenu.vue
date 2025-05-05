<template>
	<el-menu :collapse-transition="false" :collapse="flag" class="admin-menu"
		:default-active="currentRoute" :background-color="bag" text-color="#333" @select="handleSelect">
		<el-menu-item v-for="(item, index) in routes" :key="index" v-if="!item.isHidden" :index="item.path"
			:class="isActive(item.path)">
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
			activeIndex: "1",
			justSelectedPath: null
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
			const isActivePath = this.$route.path === path;
			return {
				'active-menu-item': isActivePath,
				'just-selected': isActivePath && this.justSelectedPath === path
			};
		},
		handleSelect(index) {
			this.activeIndex = index;
			this.justSelectedPath = index;
			this.$emit('select', this.activeIndex);
			sessionStorage.setItem('activeMenuItem', this.activeIndex);
			
			// 添加刷新波动效果，并在动画结束后移除类
			setTimeout(() => {
				this.justSelectedPath = null;
			}, 500);
		},
	},
};
</script>

<style scoped lang="scss">
// 定义变量
$primary-color: #409EFF;
$secondary-color: #64B5F6;
$hover-color: #FF6B9A;
$transition-bezier: cubic-bezier(0.34, 1.56, 0.64, 1);
$border-radius: 16px;
$shadow-normal: 0 6px 20px rgba(0, 0, 0, 0.06);
$shadow-active: 0 8px 24px rgba(64, 158, 255, 0.3);
$shadow-active-pulse: 0 10px 30px rgba(64, 158, 255, 0.5);
$shadow-hover: 0 6px 20px rgba(255, 107, 154, 0.2);

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

// 新增波纹动画
@keyframes ripple {
    0% {
        transform: scale(0);
        opacity: 0.6;
    }
    100% {
        transform: scale(2.5);
        opacity: 0;
    }
}

// 新增选中后的刷新动画
@keyframes refresh-wave {
    0% {
        transform: scale(0.97);
        opacity: 0.7;
    }
    50% {
        transform: scale(1.03);
        opacity: 1;
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
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
        
        // 波纹效果容器
        &::after {
            content: '';
            display: block;
            position: absolute;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 50%;
            opacity: 0;
            transform: scale(0);
            pointer-events: none;
            z-index: 1;
        }
        
        // 触发波纹效果
        &:active::after {
            animation: ripple 0.6s ease-out;
        }
        
        // 悬浮背景
        &::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: $border-radius;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.4s $transition-bezier;
            background: linear-gradient(135deg, #ff77a9, #ff9ed4);
            transform: scale(0.96);
        }
        
        // 悬浮效果
        &:hover {
            background-color: transparent;
            color: white;
            box-shadow: $shadow-hover;
            transform: translateY(-2px);
            
            &::before {
                opacity: 1;
                transform: scale(1);
            }
            
            i {
                color: white;
                transform: scale(1.1) rotate(5deg);
            }

            span {
                color: white;
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
        
        &.just-selected {
            animation: refresh-wave 0.5s ease-in-out, pulseActive 2s infinite 0.5s;
        }
        
        &::before {
            opacity: 0;
        }
        
        i, span {
            color: white;
        }
        
        i {
            // 移除图标跳动动画
            // animation: subtle-bounce 2s infinite;
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
        
        // 波纹效果在折叠状态下的位置调整
        &::after {
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%) scale(0);
        }
        
        &:active::after {
            animation: ripple 0.6s ease-out;
        }
        
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
            box-shadow: $shadow-hover;
            
            i {
                color: $hover-color;
                transform: scale(1.15) rotate(5deg);
            }
        }
    }
    
    .active-menu-item {
        background: linear-gradient(135deg, $primary-color, $secondary-color);
        box-shadow: $shadow-active;
        animation: pulseActive 2s infinite;
        
        &.just-selected {
            animation: refresh-wave 0.5s ease-in-out, pulseActive 2s infinite 0.5s;
        }
        
        i {
            color: white;
            // 移除图标跳动动画
            // animation: subtle-bounce 2s infinite;
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