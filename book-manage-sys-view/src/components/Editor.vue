<template>
    <div>
        <Toolbar style="border-bottom: 1px solid #eae8e8;" :editor="editor" :defaultConfig="toolbarConfig"
            :mode="mode" />
        <Editor :style="{ height: height, overflowY: 'hidden' }" v-model="editorContent" :defaultConfig="editorConfig"
            :mode="mode" @onCreated="onCreated" />
    </div>
</template>
<script>
import Vue from 'vue'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
export default Vue.extend({
    components: { Editor, Toolbar },
    props: {
        value: {
            type: String,
            default: '',
        },
        height: {
            type: String,
            default: 'calc(100vh - 250px)'
        }
    },
    data() {
        return {
            editor: null,
            editorContent: this.value || '<p>请输入内容...</p>',
            toolbarConfig: {},
            editorConfig: {
                placeholder: '请输入内容...',
                MENU_CONF: {
                    uploadImage: {
                        server: '/api/book-manage-sys-api/v1.0/file/upload',
                        fieldName: 'file',
                        maxFileSize: 10 * 1024 * 1024,
                        maxNumberOfFiles: 10,
                        // allowedFileTypes: ['image/*'],
                        metaWithUrl: false,
                        withCredentials: true,
                        timeout: 10 * 1000,
                        headers: {
                            'token': sessionStorage.getItem('token')
                        },
                        customInsert(res, insertFn) {
                            insertFn(res.data, res.data, res.data);
                        },
                    },
                    uploadVideo: {
                        server: '/api/book-manage-sys-api/v1.0/file/upload',
                        fieldName: 'file',
                        maxFileSize: 100 * 1024 * 1024,
                        headers: {
                            'token': sessionStorage.getItem('token')
                        },
                        timeout: 60 * 1000,
                        customInsert(res, insertFn) {
                            insertFn(res.data, res.data);
                        },
                    }
                }
            },
            mode: 'default',
        }
    },
    methods: {
        onCreated(editor) {
            this.editor = Object.seal(editor);
            this.toolbarConfig.excludeKeys = ['group-video','insertLink','fullScreen','emotion','insertTable'];
        },
    },
    watch: {
        value: {
            handler(newVal) {
                if (newVal !== this.editorContent) {
                    this.editorContent = newVal || '<p>请输入内容...</p>';
                }
            },
            immediate: true
        },
        editorContent: {
            handler(newVal) {
                this.$emit('input', newVal);
            },
            deep: true
        }
    },
    beforeDestroy() {
        const editor = this.editor;
        if (editor == null) return;
        editor.destroy();
    }
})
</script>
<style src="@wangeditor/editor/dist/css/style.css"></style>
<style scoped>
.line-number {
    display: block;
    margin-right: 10px;
    /* 以下样式确保行号不被选中或复制 */
    pointer-events: none;
    user-select: none;
    -webkit-user-select: none;
    color: #999;
    /* 行号颜色，可自定义 */
    text-align: right;
    /* 行号对齐方式 */
}
</style>