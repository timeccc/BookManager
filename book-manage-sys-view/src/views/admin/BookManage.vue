<template>
    <el-row class="book-manage-container">
        <el-row style="padding: 10px 16px;margin: 0;">
            <el-row>
                <el-date-picker style="width: 216px;margin-right: 5px;" @change="fetchFreshData" size="small"
                    v-model="searchTime" type="daterange" range-separator="至" start-placeholder="创建开始"
                    end-placeholder="创建结束">
                </el-date-picker>
                <el-input size="small" style="width: 166px;" v-model="bookQueryDto.name" placeholder="书名" clearable
                    @clear="handleFilterClear">
                    <el-button slot="append" @click="handleFilter" icon="el-icon-search"></el-button>
                </el-input>
                <span class="edit-button" style="float: right;" @click="add()">
                    <i class="el-icon-plus" style="margin-right: 5px;"></i>新增书籍
                </span>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 16px;">
            <el-row :gutter="20">
                <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6" v-for="(book, index) in tableData"
                    :key="index" class="book-col">
                    <div class="item-book">
                        <div style="display: flex;justify-content: center;">
                            <img style="width: 150px;max-height: 180px;border-radius: 8px;box-shadow: 0 4px 12px rgba(0,0,0,0.1);" :src="book.cover" alt="">
                        </div>
                        <div style="padding: 15px 14px; text-align: center;">
                            <div style="color: rgb(51,51,51);font-size: 20px;font-weight: bold;margin-bottom: 10px;">
                                <el-tooltip class="item" effect="dark" :content="book.name" placement="top">
                                    <div class="title" style="margin: 0 auto;">{{ book.name }}</div>
                                </el-tooltip>
                            </div>
                            <div style="font-size: 13px;color: rgb(51,51,51);margin-bottom: 12px;">
                                <div class="title" style="margin: 0 auto 10px auto;">
                                    <i v-if="book.isPlanBuy" style="margin-right: 5px;" class="el-icon-warning"></i>
                                    <i v-else style="margin-right: 5px;color: rgb(253, 199, 50);"
                                        class="el-icon-success"></i>
                                    <el-tooltip v-if="book.isPlanBuy" class="item" effect="dark"
                                        content="计划上架的书籍，为预售书籍。用户可以订阅，书籍上架之后将做通知" placement="top">
                                        <span
                                            style="text-decoration: underline;text-decoration-style: dashed;">预售书籍</span>
                                    </el-tooltip>
                                    <span v-else>书籍已上架</span>
                                    <span> - {{ book.categoryName }}</span>
                                </div>
                                <div style="font-size: 13px; margin-bottom: 8px;">
                                    <el-tooltip class="item" effect="dark" :content="book.publisher"
                                        placement="top">
                                        <div class="title" style="margin: 0 auto;">由【{{ book.publisher }}】出版</div>
                                    </el-tooltip>
                                </div>
                                <div style="margin-bottom: 15px;">
                                    <el-tooltip class="item" effect="dark" :content="book.author"
                                        placement="top">
                                        <div class="title" style="margin: 0 auto;">
                                            <span style="margin-right: 5px;">作者：{{ book.author }}</span>
                                            <span>【库存{{ book.num }}本】</span>
                                        </div>
                                    </el-tooltip>
                                </div>
                                <div class="book-actions">
                                    <button @click="handleEdit(book)" class="book-btn edit-btn">修改</button>
                                    <button @click="handleDelete(book)" class="book-btn delete-btn">删除</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </el-col>
            </el-row>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[8, 16]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <el-dialog :show-close="false" :visible.sync="dialogOperation" width="40%">
            <div slot="title">
                <p class="dialog-title">{{ !isOperation ? '新增书籍' : '修改书籍' }}</p>
            </div>
            <div style="padding:0 20px 40px 15px;">
                <el-row>
                    <el-col :span="8">
                        <div class="point">书籍封面</div>
                        <el-upload class="avatar-uploader" action="/api/book-manage-sys-api/v1.0/file/upload"
                            :show-file-list="false" :on-success="handleBookCoverSuccess">
                            <img v-if="cover" :src="cover" class="dialog-cover">
                            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                        </el-upload>
                        <div style="margin-bottom: 8px;">
                            <div class="point">*书架</div>
                            <el-select v-model="data.bookShelfId" placeholder="请选择">
                                <el-option v-for="(item, index) in bookshelfOptions" :key="index"
                                    :label="bookshelfConfig(item)" :value="item.id">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <div class="point">*书籍类别</div>
                            <el-select v-model="data.categoryId" placeholder="请选择">
                                <el-option v-for="(item, index) in options" :key="index" :label="item.name"
                                    :value="item.id">
                                </el-option>
                            </el-select>
                        </div>
                        <div v-if="!isOperation || data.isPlanBuy">
                            <p>上线只需要设置为未预售即可</p>
                            <div style="margin-bottom: 8px;">
                                <div class="point">*是否为预售书籍(预售才选)</div>
                                <el-switch v-model="data.isPlanBuy" active-color="#13ce66"
                                    inactive-color="rgb(245, 245, 245)">
                                </el-switch>
                            </div>
                            <div style="margin-bottom: 8px;">
                                <div class="point">*计划上架时间(预售才选)</div>
                                <el-date-picker v-model="data.planBuyTime" type="date" placeholder="计划上架时间">
                                </el-date-picker>
                            </div>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <div class="point">馆藏数目</div>
                            <el-input-number size="small" v-model="data.num" :min="1" :max="100"
                                label=""></el-input-number>
                        </div>
                    </el-col>
                    <el-col :span="16">
                        <div style="margin-left: 40px;">
                            <div style="margin-bottom: 8px;">
                                <div class="point">书籍名称</div>
                                <input class="dialog-input" v-model="data.name" placeholder="输入" />
                            </div>
                            <div style="margin-bottom: 8px;">
                                <div class="point">出版商</div>
                                <input class="dialog-input" v-model="data.publisher" placeholder="输入" />
                            </div>
                            <div style="margin-bottom: 8px;">
                                <div class="point">作者</div>
                                <input class="dialog-input" v-model="data.author" placeholder="输入" />
                            </div>
                            <div style="margin-bottom: 8px;">
                                <div class="point">国际标准书号(ISBN)</div>
                                <input class="dialog-input" v-model="data.isbn" placeholder="输入" />
                            </div>
                            <div>
                                <div class="point">书籍简介</div>
                                <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4 }" placeholder="书籍简介"
                                    v-model="data.detail">
                                </el-input>
                            </div>
                        </div>
                    </el-col>
                </el-row>

            </div>
            <span slot="footer" class="dialog-footer">
                <span class="channel-button" @click="cannel()">
                    取消操作
                </span>
                <span class="edit-button" v-if="!isOperation" @click="addOperation()">
                    确定新增
                </span>
                <span class="edit-button" v-else @click="updateOperation()">
                    确定修改
                </span>
            </span>
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
            pageSize: 8,
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
    padding: 15px;
    box-sizing: border-box;
    border-radius: 12px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    border: 1px solid rgba(230, 230, 230, 0.5);
    height: 100%;
    
    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
    }
}

.book-col {
    padding: 10px;
    margin-bottom: 15px;
}

.book-actions {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 10px;
}

.book-btn {
    padding: 4px 14px;
    border: none;
    border-radius: 16px;
    font-size: 12px !important;
    font-weight: 400;
    cursor: pointer;
    transition: all 0.3s ease;
    color: white;
    outline: none;
    min-width: 50px;
    height: 26px;
    line-height: 18px;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
}

.edit-btn {
    background-color: #409EFF;
    box-shadow: 0 2px 5px rgba(64, 158, 255, 0.2);
}

.edit-btn:hover {
    background-color: #66b1ff;
}

.delete-btn {
    background-color: #F56C6C;
    box-shadow: 0 2px 5px rgba(245, 108, 108, 0.2);
}

.delete-btn:hover {
    background-color: #f78989;
}

.edit-button {
    background-color: #409EFF;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
    font-weight: 500;
}

.edit-button:hover {
    background-color: #66b1ff;
    box-shadow: 0 4px 10px rgba(64, 158, 255, 0.4);
    transform: translateY(-2px);
}
</style>