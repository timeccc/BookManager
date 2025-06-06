module.exports = {
    lintOnSave: false,
    devServer: {
        host: "localhost",
        port: 2025,
        https: false,
        proxy: "http://localhost:2024",
        //disableHostCheck: true,
        overlay: {
            warning: false,
            errors: false
        },
    }
}