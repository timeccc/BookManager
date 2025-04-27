<template>
	<el-menu :collapse-transition="false" :collapse="flag" class="glass-menu"
		:default-active="currentRoute" :background-color="bag" text-color="#333" @select="handleSelect">
		<el-menu-item v-for="(item, index) in routes" :key="index" style="width: 100%;"
			v-if="!item.isHidden" :index="item.path"
			:class="{ 'is-active': isActive(item.path) }">
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
			isCollapse: true,
			selectedMenuItem: '',
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

<style scoped>
.glass-menu {
    border-right: none !important;
    width: 100% !important; /* 确保菜单始终占满容器 */
    max-width: 220px;
    min-width: 200px; /* 设置最小宽度，避免缩放问题 */
    padding: 5px 12px;
    background-color: transparent !important;
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
    border-radius: 16px;
    box-shadow: 0 8px 25px rgba(31, 38, 135, 0.08);
    margin: 0 5px 10px 5px;
    transition: all 0.3s ease;
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-sizing: border-box; /* 确保padding不会影响宽度计算 */
}

/* Element UI菜单项默认焦点样式覆盖 */
.el-menu-item.is-active {
    color: white !important;
}

.is-active {
	background: linear-gradient(135deg, rgba(81, 136, 253, 0.9), rgba(124, 183, 251, 0.9)) !important;
	color: white !important;
	font-weight: bold;
	border-radius: 12px;
	box-shadow: 0 4px 15px rgba(81, 136, 253, 0.3);
	position: relative;
	overflow: hidden;
	transition: all 0.3s ease;
}

.is-active i, .is-active span {
    color: white !important;
}

.is-active::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: 0.5s;
    animation: shine 3s infinite;
}

@keyframes shine {
    0% {
        left: -100%;
    }
    35% {
        left: 100%;
    }
    100% {
        left: 100%;
    }
}

.el-menu-item,
.el-submenu__title {
	height: 50px !important;
	line-height: 50px !important;
	user-select: none;
	color: #333;
	transition: all 0.3s ease;
	font-size: 15px;
	letter-spacing: 0.5px;
}

.el-menu-item i {
    font-size: 18px !important;
    margin-right: 5px;
    color: #555;
    transition: all 0.3s ease;
}

.el-menu-item:focus {
    background-color: transparent !important;
}

.el-menu-item:hover {
	box-sizing: border-box;
	border-radius: 12px;
	background: rgba(235, 242, 255, 0.7) !important;
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.07);
	color: #3a8ee6 !important;
}

.el-menu-item:hover i {
    color: #3a8ee6;
}

.el-menu-item {
	height: 50px !important;
	line-height: 50px !important;
	margin: 6px 0;
	border-radius: 12px;
	padding: 0 15px;
	position: relative;
	overflow: hidden;
}

.el-menu-item span {
    font-weight: 500;
	color: #333;
	transition: all 0.3s ease;
}

/* 折叠模式下的样式优化 */
.el-menu--collapse {
    width: auto !important;
    min-width: 70px !important;
}

.el-menu--collapse .el-menu-item {
    padding: 0 !important;
    text-align: center;
}

.el-menu--collapse .el-menu-item i {
    margin: 0 !important;
    font-size: 22px !important;
}
</style>