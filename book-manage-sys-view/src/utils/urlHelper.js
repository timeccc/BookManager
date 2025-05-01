/**
 * URL助手工具函数 - 用于根据当前环境动态生成API地址
 */

// 开发环境中，保留使用本地代理
const isDev = process.env.NODE_ENV === 'development';
// 您的公网IP地址
const PUBLIC_IP = '111.49.86.107';
// 支持的本地网络IP地址列表
const LOCAL_IP_LIST = ['192.168.0.100', '10.17.40.129'];

/**
 * 获取当前有效的本地IP地址
 * @returns {string} 可用的本地IP地址
 */
function getActiveLocalIP() {
    // 这里使用简单的方法 - 检查当前主机名
    const hostname = window.location.hostname;

    // 如果当前hostname正好是我们支持的IP之一，直接返回
    if (LOCAL_IP_LIST.includes(hostname)) {
        return hostname;
    }

    // 默认返回第一个IP (首选IP)
    return '127.0.0.1'; // 总是使用localhost对应的IP
}

/**
 * 获取基础API URL
 * @returns {string} 基础API地址
 */
export function getBaseUrl() {
    const hostname = window.location.hostname;

    // localhost访问时，始终使用相对路径
    if (hostname === 'localhost' || hostname === '127.0.0.1') {
        return '/api/book-manage-sys-api/v1.0';
    } else if (hostname.includes('ngrok') || hostname === PUBLIC_IP || LOCAL_IP_LIST.includes(hostname)) {
        // 通过ngrok、公网IP或已知本地IP访问
        return '/api/book-manage-sys-api/v1.0';
    } else {
        // 其他情况（如通过其他设备访问），尝试使用活跃的本地IP
        const activeIP = getActiveLocalIP();
        return `http://${activeIP}:2024/api/book-manage-sys-api/v1.0`;
    }
}

/**
 * 获取文件上传URL
 * @returns {string} 文件上传地址
 */
export function getUploadUrl() {
    const hostname = window.location.hostname;
    const origin = window.location.origin; // 获取当前完整的源地址

    // 本地开发环境，始终使用当前域名的路径
    if (hostname === 'localhost' || hostname === '127.0.0.1') {
        return `${origin}/api/book-manage-sys-api/v1.0/file/upload`;
    } else if (hostname.includes('ngrok') || hostname === PUBLIC_IP || LOCAL_IP_LIST.includes(hostname)) {
        // 通过ngrok、公网IP或已知本地IP访问，使用当前域名
        return `${origin}/api/book-manage-sys-api/v1.0/file/upload`;
    } else {
        // 其他情况使用活跃的本地IP
        const activeIP = getActiveLocalIP();
        return `http://${activeIP}:2024/api/book-manage-sys-api/v1.0/file/upload`;
    }
}