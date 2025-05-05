<template>
    <el-row class="book-manage-container">
        <el-row style="padding: 10px 16px;margin: 0;">
            <el-row class="search-bar-container">
                <el-date-picker style="width: 216px;margin-right: 10px;" @change="fetchFreshData" size="small"
                    v-model="searchTime" type="daterange" range-separator="-" start-placeholder="创建开始"
                    end-placeholder="创建结束">
                </el-date-picker>
                <el-input size="small" style="width: 166px; margin-right: 5px;" v-model="bookQueryDto.name" placeholder="书名" clearable
                    @clear="handleFilterClear">
                </el-input>
                <el-button size="small" @click="handleFilter" icon="el-icon-search"></el-button>
                <span class="new-book-btn" @click="add()">
                    <i class="el-icon-plus"></i>新增书籍
                </span>
            </el-row>
        </el-row>
        <el-row style="margin: 8px 12px;">
            <div class="book-grid">
                <div v-for="(book, index) in tableData" :key="index" class="book-col">
                    <div class="item-book">
                        <div style="display: flex;flex-direction: column;align-items: center;">
                            <img style="width: 120px;max-height: 140px;border-radius: 8px;box-shadow: 0 4px 12px rgba(0,0,0,0.1);" :src="book.cover" alt="">
                        
                            <div style="width: 100%; padding: 10px 0;">
                                <div style="color: rgb(51,51,51);font-size: 16px;font-weight: bold;margin-bottom: 10px; text-align: center;">
                                <el-tooltip class="item" effect="dark" :content="book.name" placement="top">
                                    <div class="title" style="margin: 0 auto;">{{ book.name }}</div>
                                </el-tooltip>
                            </div>
                                <div style="font-size: 12px;color: rgb(51,51,51);margin-bottom: 8px; text-align: left; padding-left: 12px;">
                                    <div class="title" style="margin: 0 0 5px 0;">
                                    <i v-if="book.isPlanBuy" style="margin-right: 5px;color: #E6A23C;" class="el-icon-warning"></i>
                                    <i v-else style="margin-right: 5px;color: #67C23A;" class="el-icon-success"></i>
                                    <el-tooltip v-if="book.isPlanBuy" class="item" effect="dark"
                                        content="计划上架的书籍，为预售书籍。用户可以订阅，书籍上架之后将做通知" placement="top">
                                            <span style="text-decoration: underline;text-decoration-style: dashed;">预售书籍</span>
                                    </el-tooltip>
                                    <span v-else>书籍已上架</span>
                                    <span> - {{ book.categoryName }}</span>
                                </div>
                                <div style="font-size: 12px; margin-bottom: 4px;">
                                        <el-tooltip class="item" effect="dark" :content="book.publisher" placement="top">
                                            <div class="title" style="margin: 0;">由【{{ book.publisher }}】出版</div>
                                    </el-tooltip>
                                </div>
                                <div style="margin-bottom: 8px;">
                                        <el-tooltip class="item" effect="dark" :content="book.author" placement="top">
                                            <div class="title" style="margin: 0;">
                                            <span style="margin-right: 4px;">作者：{{ book.author }}</span>
                                            <span>【库存{{ book.num }}本】</span>
                                        </div>
                                    </el-tooltip>
                                </div>
                                </div>
                                <div class="book-actions" style="padding-left: 12px; justify-content: flex-start;">
                                    <button @click="handleEdit(book)" class="book-btn edit-btn">修改</button>
                                    <button @click="handleDelete(book)" class="book-btn delete-btn">删除</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[10, 20]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <el-dialog :show-close="false" :visible.sync="dialogOperation" width="600px" :top="'8vh'" custom-class="book-dialog">
            <div class="dialog-header">
                <h3 class="dialog-title">{{ !isOperation ? '新增书籍' : '修改书籍' }}</h3>
            </div>
            <div class="dialog-content">
                <el-row :gutter="20">
                    <el-col :span="9">
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-picture-outline"></i> 书籍封面</label>
                            <el-upload class="book-cover-uploader" action="/api/book-manage-sys-api/v1.0/file/upload"
                                :show-file-list="false" :on-success="handleBookCoverSuccess">
                                <img v-if="cover" :src="cover" class="book-cover-image">
                                <div v-else class="book-cover-placeholder">
                                    <i class="el-icon-plus"></i>
                                </div>
                            </el-upload>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-s-grid"></i> 书架位置 <span class="required">*</span></label>
                            <el-select v-model="data.bookShelfId" placeholder="请选择" size="small" style="width: 100%;">
                                <el-option v-for="(item, index) in bookshelfOptions" :key="index"
                                    :label="bookshelfConfig(item)" :value="item.id">
                                </el-option>
                            </el-select>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-collection-tag"></i> 书籍类别 <span class="required">*</span></label>
                            <el-select v-model="data.categoryId" placeholder="请选择" size="small" style="width: 100%;">
                                <el-option v-for="(item, index) in options" :key="index" :label="item.name"
                                    :value="item.id">
                                </el-option>
                            </el-select>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-goods"></i> 馆藏数目</label>
                            <el-input-number size="small" v-model="data.num" :min="1" :max="100"
                                style="width: 100%;"></el-input-number>
                        </div>
                    </el-col>
                    <el-col :span="15">
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-reading"></i> 书籍名称</label>
                            <input class="dialog-input" v-model="data.name" placeholder="请输入书籍名称" />
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-office-building"></i> 出版社</label>
                            <input class="dialog-input" v-model="data.publisher" placeholder="请输入出版社" />
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-user"></i> 作者</label>
                            <input class="dialog-input" v-model="data.author" placeholder="请输入作者" />
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-document"></i> 国际标准书号(ISBN)</label>
                            <input class="dialog-input" v-model="data.isbn" placeholder="请输入ISBN" />
                        </div>
                        <div class="form-group">
                            <label class="form-label"><i class="el-icon-notebook-2"></i> 书籍简介</label>
                            <el-input type="textarea" :autosize="{ minRows: 3, maxRows: 3 }" placeholder="请输入书籍简介"
                                v-model="data.detail" size="small">
                            </el-input>
                        </div>
                        <div class="form-group" v-if="!isOperation || data.isPlanBuy">
                            <label class="form-label"><i class="el-icon-time"></i> 预售设置 <span class="required">*</span></label>
                            <div class="presale-group">
                                <el-switch v-model="data.isPlanBuy" active-color="#13ce66"
                                    inactive-color="#dcdfe6">
                                </el-switch>
                                <span class="switch-label">{{ data.isPlanBuy ? '预售书籍' : '立即上架' }}</span>
                                <el-date-picker v-if="data.isPlanBuy" v-model="data.planBuyTime" type="date" 
                                    placeholder="计划上架时间" size="small" style="width: 140px; margin-left: 10px;">
                                </el-date-picker>
                            </div>
                        </div>
                    </el-col>
                </el-row>
            </div>
            <div class="dialog-footer">
                <el-button class="cancel-btn" size="small" @click="cannel()">取消操作</el-button>
                <el-button v-if="!isOperation" class="confirm-btn" type="primary" size="small" @click="addOperation()">确定新增</el-button>
                <el-button v-else class="confirm-btn" type="primary" size="small" @click="updateOperation()">确定修改</el-button>
            </div>
        </el-dialog>
    </el-row>
</template>

<script>
export default {
    data() {
        return {
            data: {num: 1},
            currentPage: 1,
            cover: null,
            pageSize: 10,
            totalItems: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            delectedRows: [],
            bookQueryDto: {}, // 搜索条件
            options: [],
            bookshelfOptions: [],
            searchTime: [],
        };
    },
    created() {
        this.fetchFreshData();
        this.fetchCategory();
        this.fetchBookshelf();
    },
    methods: {
        cannel() {
            this.dialogOperation = false;
            this.isOperation = false;
            this.cover = '';
            this.data = {};
            // 清理多余的遮罩层
            this.$nextTick(() => {
                const modals = document.querySelectorAll('.v-modal');
                if (modals.length > 1) {
                    for (let i = 1; i < modals.length; i++) {
                        modals[i].parentNode.removeChild(modals[i]);
                    }
                }
            });
        },
        bookshelfConfig(item) {
            return item.floor + "-" + item.area + "-" + item.frame;
        },
        handleBookCoverSuccess(res, file) {
            if (res.code !== 200) {
                this.$message.error(`书籍封面上传异常`);
                return;
            }
            this.$message.success(`书籍封面上传成功`);
            this.cover = res.data;
        },
        fetchBookshelf() {
            this.$axios.post('bookshelf/query', {}).then(res => {
                if (res.data.code === 200) {
                    this.bookshelfOptions = res.data.data;
                }
            })
        },
        fetchCategory() {
            this.$axios.post('category/query', {}).then(res => {
                if (res.data.code === 200) {
                    this.options = res.data.data;
                }
            })
        },
        // 多选框选中
        handleSelectionChange(selection) {
            this.delectedRows = selection;
        },
        // 批量删除数据
        async batchDelete() {
            if (!this.delectedRows.length) {
                this.$message(`未选中任何数据`);
                return;
            }
            const confirmed = await this.$swalConfirm({
                title: '删除书籍书籍数据',
                text: `删除后不可恢复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = this.delectedRows.map(entity => entity.id);
                    const response = await this.$axios.post(`/book/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$swal.fire({
                            title: '删除提示',
                            text: response.data.msg,
                            icon: 'success',
                            showConfirmButton: false,
                            timer: 2000,
                        });
                        this.fetchFreshData();
                        return;
                    }
                } catch (e) {
                    this.$swal.fire({
                        title: '错误提示',
                        text: e,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 2000,
                    });
                    console.error(`书籍书籍信息删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.bookQueryDto = {};
            this.fetchFreshData();
        },
        // 修改信息
        async updateOperation() {
            try {
                this.data.cover = this.cover;
                const response = await this.$axios.put('/book/update', this.data);
                this.$swal.fire({
                    title: '书籍书籍信息修改',
                    text: response.data.msg,
                    icon: response.data.code === 200 ? 'success' : 'error',
                    showConfirmButton: false,
                    timer: 1000,
                });
                if (response.data.code === 200) {
                    this.closeDialog();
                    this.fetchFreshData();
                    this.clearFormData();
                }
            } catch (error) {
                console.error('提交表单时出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        // 信息新增
        async addOperation() {
            try {
                this.data.cover = this.cover;
                const response = await this.$axios.post('/book/save', this.data);
                this.$message[response.data.code === 200 ? 'success' : 'error'](response.data.msg);
                if (response.data.code === 200) {
                    this.closeDialog();
                    this.fetchFreshData();
                    this.clearFormData();
                }
            } catch (error) {
                console.error('提交表单时出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        closeDialog() {
            this.dialogOperation = false;
        },
        clearFormData() {
            this.data = {};
            this.cover = null;
        },
        async fetchFreshData() {
            try {
                this.tableData = [];
                let startTime = null;
                let endTime = null;
                if (this.searchTime != null && this.searchTime.length === 2) {
                    const [startDate, endDate] = await Promise.all(this.searchTime.map(date => date.toISOString()));
                    startTime = `${startDate.split('T')[0]}T00:00:00`;
                    endTime = `${endDate.split('T')[0]}T23:59:59`;
                }
                // 请求参数
                const params = {
                    current: this.currentPage,
                    size: this.pageSize,
                    startTime: startTime,
                    endTime: endTime,
                    ...this.bookQueryDto
                };
                const response = await this.$axios.post('/book/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询书籍书籍信息异常:', error);
            }
        },
        add() {
            this.dialogOperation = true;
        },
        handleFilter() {
            this.currentPage = 1;
            this.fetchFreshData();
        },
        handleFilterClear() {
            this.handleFilter();
        },
        handleSizeChange(val) {
            this.pageSize = val;
            this.currentPage = 1;
            this.fetchFreshData();
        },
        handleCurrentChange(val) {
            this.currentPage = val;
            this.fetchFreshData();
        },
        messagePush(row) {
            this.data = { ...row };
        },
        handleEdit(row) {
            this.dialogOperation = true;
            this.isOperation = true;
            this.data = { ...row };
            this.cover = row.cover;
        },
        handleDelete(row) {
            this.delectedRows.push(row);
            this.batchDelete();
        }
    },
};
</script>
<style lang="scss">
/* 全局样式移除，使用Element UI原生样式 */
</style>
<style scoped lang="scss">
.book-manage-container {
    background-color: #FFFFFF;
    padding: 20px 0;
    border-radius: 16px;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    box-sizing: border-box;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.03);
}

.search-bar-container {
    display: flex;
    align-items: center;
}

.list-cover {
    width: 50px;
    height: 70px;
    border-radius: 5px;
}

.title {
    width: 160px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    margin: 0 auto;
}

.item-book {
    background-color: white;
    padding: 12px;
    box-sizing: border-box;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease;
    border: 1px solid rgba(230, 230, 230, 0.5);
    height: 100%;
    
    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    }
}

.book-actions {
    display: flex;
    justify-content: center;
    gap: 12px;
    margin-top: 12px;
}

.book-btn {
    padding: 4px 12px !important;
    border: none !important;
    border-radius: 10px !important;
    font-size: 12px !important;
    font-weight: 500 !important;
    cursor: pointer !important;
    transition: all 0.3s ease !important;
    color: white !important;
    outline: none !important;
    min-width: 44px !important;
    height: 24px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
}

.edit-btn {
    background-color: #409EFF !important;
    box-shadow: 0 1px 3px rgba(64, 158, 255, 0.2) !important;
}

.edit-btn:hover {
    background-color: #66b1ff !important;
}

.delete-btn {
    background-color: #F56C6C !important;
    box-shadow: 0 1px 3px rgba(245, 108, 108, 0.2) !important;
}

.delete-btn:hover {
    background-color: #f78989 !important;
}

.edit-button {
    background-color: #409EFF !important;
    color: white !important;
    padding: 8px 16px !important;
    border-radius: 20px !important;
    cursor: pointer !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3) !important;
    font-weight: 500 !important;
    display: inline-block !important;
}

.edit-button:hover {
    background-color: #66b1ff !important;
    box-shadow: 0 4px 10px rgba(64, 158, 255, 0.4) !important;
    transform: translateY(-2px) !important;
}

.dialog-input {
    width: 100%;
    padding: 6px 8px;
    border: 1px solid #DCDFE6;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 12px;
    font-weight: 400;
    color: #606266;
}

.dialog-input:focus {
    border-color: #409EFF;
    outline: none;
}

.point {
    font-size: 12px;
    color: #606266;
    margin-bottom: 3px;
    font-weight: 400;
}

.dialog-title {
    font-size: 15px;
    font-weight: 500;
    color: #303133;
    margin: 0;
    padding: 8px 0;
}

.dialog-btn {
    display: inline-block !important;
    padding: 6px 15px !important;
    border-radius: 16px !important;
    cursor: pointer !important;
    transition: all 0.3s ease !important;
    font-size: 12px !important;
    font-weight: 400 !important;
    margin-left: 10px !important;
}

.cancel-btn {
    background-color: #F5F7FA !important;
    color: #606266 !important;
    border: 1px solid #DCDFE6 !important;
}

.cancel-btn:hover {
    color: #409EFF !important;
    border-color: #c6e2ff !important;
    background-color: #ECF5FF !important;
}

.confirm-btn {
    background-color: #409EFF !important;
    color: white !important;
    border: none !important;
    box-shadow: 0 2px 6px rgba(64, 158, 255, 0.2) !important;
}

.confirm-btn:hover {
    background-color: #66b1ff !important;
}

.avatar-uploader {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-bottom: 10px;
}

.avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 120px;
    height: 120px;
    line-height: 120px;
    text-align: center;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
}

.dialog-cover {
    width: 120px;
    height: 120px;
    display: block;
    border-radius: 6px;
    object-fit: cover;
}

.book-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 16px;
    margin-bottom: 20px;
}

.book-col {
    padding: 0;
    margin-bottom: 0;
}

// 响应式调整
@media (max-width: 1500px) {
    .book-grid {
        grid-template-columns: repeat(5, 1fr);
    }
}

@media (max-width: 1300px) {
    .book-grid {
        grid-template-columns: repeat(4, 1fr);
    }
}

@media (max-width: 1000px) {
    .book-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (max-width: 768px) {
    .book-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 576px) {
    .book-grid {
        grid-template-columns: repeat(1, 1fr);
    }
}

// 书籍对话框样式
.book-dialog {
    border-radius: 8px;
    overflow: hidden;
    
    .el-dialog__header {
        display: none; // 隐藏原来的标题区域
    }
    
    .el-dialog__body {
        padding: 0;
    }
}

.dialog-header {
    background-color: #f9f9f9;
    padding: 14px 20px;
    border-bottom: 1px solid #ebeef5;
}

.dialog-content {
    padding: 16px 20px;
}

.dialog-title {
    font-size: 16px;
    font-weight: 600;
    color: #303133;
    margin: 0;
    padding: 0;
    position: relative;
    display: inline-block;
    
    &:after {
        content: '';
        position: absolute;
        bottom: -6px;
        left: 0;
        width: 30px;
        height: 2px;
        background-color: #409EFF;
    }
}

.dialog-footer {
    padding: 10px 20px 16px;
    text-align: right;
    border-top: 1px solid #ebeef5;
}

.form-label {
    font-size: 13px;
    color: #606266;
    margin-bottom: 6px;
    font-weight: 500;
    display: block;
    
    i {
        margin-right: 5px;
        color: #409EFF;
    }
    
    .required {
        color: #F56C6C;
        margin-left: 2px;
    }
}

.form-group {
    margin-bottom: 12px;
}

.dialog-input {
    width: 100%;
    padding: 8px 10px;
    border: 1px solid #DCDFE6;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 13px;
    color: #606266;
    
    &:focus {
        border-color: #409EFF;
        outline: none;
    }
}

.book-cover-uploader {
    margin-bottom: 12px;
    display: flex;
    justify-content: center;
}

.book-cover-image {
    width: 150px;
    height: 150px;
    display: block;
    object-fit: cover;
    border-radius: 4px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.book-cover-placeholder {
    width: 150px;
    height: 150px;
    line-height: 150px;
    text-align: center;
    border: 1px dashed #d9d9d9;
    border-radius: 4px;
    background-color: #fafafa;
    font-size: 24px;
    color: #8c939d;
    cursor: pointer;
    transition: all 0.3s;
    
    &:hover {
        border-color: #409EFF;
        color: #409EFF;
    }
}

.presale-group {
    display: flex;
    align-items: center;
    
    .switch-label {
        margin-left: 10px;
        font-size: 13px;
        color: #606266;
    }
}

.cancel-btn, .confirm-btn {
    padding: 7px 16px;
    font-size: 13px;
    border-radius: 4px;
    
    &:focus {
        outline: none;
    }
}

.cancel-btn {
    &:hover {
        color: #409EFF;
        border-color: #c6e2ff;
        background-color: #ecf5ff;
    }
}

.confirm-btn {
    &:hover {
        background-color: #66b1ff;
        border-color: #66b1ff;
    }
}

// 添加按钮悬停效果
.add-button {
    &:hover {
        background-color: #85ce61;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(103, 194, 58, 0.4);
    }
}

// 分页样式美化
::v-deep .el-pagination {
    .el-pagination__total {
        font-weight: 500;
    }
    
    .el-pagination__sizes {
        .el-input .el-input__inner {
            border-radius: 4px;
            transition: all 0.3s;
            
            &:hover, &:focus {
                border-color: #409EFF;
            }
        }
    }
    
    .el-pager li {
        border-radius: 4px;
        transition: all 0.3s;
        
        &:hover {
            color: #409EFF;
        }
        
        &.active {
            background-color: #409EFF;
            color: #fff;
        }
    }
    
    .btn-prev, .btn-next {
        border-radius: 4px;
        
        &:hover {
            color: #409EFF;
        }
    }
}

.new-book-btn {
    padding: 7px 20px;
    background-color: #67c23a;
    color: white;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s;
    margin-left: auto;
    font-size: 14px;
    box-shadow: 0 2px 6px rgba(103, 194, 58, 0.3);
    float: right;
    
    i {
        margin-right: 5px;
        font-size: 12px;
    }
    
    &:hover {
        background-color: #85ce61;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(103, 194, 58, 0.4);
    }
}
</style>