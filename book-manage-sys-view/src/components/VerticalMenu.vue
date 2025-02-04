<template>
	<el-menu :collapse-transition="false" :collapse="flag" style="padding: 5px 20px;max-width: 253px;"
		:default-active="activeIndex" :background-color="bag" text-color="#666" @select="handleSelect">
		<el-menu-item v-for="(item, index) in routes" :key="index" style="width: 100%;"
			v-if="!item.isHidden" :index="item.path"
			:class="{ 'is-active': activeIndex === item.path }">
			<i :class="item.icon" style="font-size: 20px;"></i>
			<span slot="title" style="font-size: 14px;">{{ item.name }}</span>
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
			default: 'rgb(248,248,248)'
		}
	},
	created(){
		// 上次选中路径
		const saveLastPath = sessionStorage.getItem('activeMenuItem');
		if(saveLastPath === null){
			// 加载首页
			this.handleSelect('/adminLayout');
		}else{
			this.handleSelect(saveLastPath);
		}
	},
	methods: {
		handleSelect(index) {
			this.activeIndex = index;
			this.$emit('select', this.activeIndex);
			sessionStorage.setItem('activeMenuItem', this.activeIndex);
		},
	},
};
</script>

<style scoped>
.is-active {
	background-color: rgb(242,242,242) !important;
	color: #1c1c1c !important;
	font-weight: bold;
	border-radius: 6px;
}

.el-menu-item,
.el-submenu__title {
	height: 45px !important;
	line-height: 45px !important;
	user-select: none;
	color: #333;
}

.el-menu-item:focus,
.el-menu-item:hover {
	box-sizing: border-box;
	border-radius: 5px;
	background-color: rgb(242,242,242) !important;
}

.el-menu-item {
	height: 45px !important;
	line-height: 45px !important;
	margin: 3px;
}

</style>