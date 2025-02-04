package cn.kmbeast.context;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户身份支持器
 *
 * @author 【B站：程序员晨星】
 */
public class LocalThreadHolder {

    private static final ThreadLocal<Map<String, Integer>> USER_HOLDER = new ThreadLocal<>();

    /**
     * 设置用户信息
     *
     * @param userId   用户ID
     * @param userRole 用户角色
     * @author 【B站：程序员晨星】
     */
    public static void setUserId(Integer userId, Integer userRole) {
        Map<String, Integer> map = new HashMap<>();
        map.put("userId", userId);
        map.put("userRole", userRole);
        USER_HOLDER.set(map);
    }

    /**
     * 取出用户ID
     *
     * @return Integer
     * @author 【B站：程序员晨星】
     */
    public static Integer getUserId() {
        return USER_HOLDER.get().get("userId");
    }

    /**
     * 取出用户角色
     *
     * @return Integer
     * @author 【B站：程序员晨星】
     */
    public static Integer getRoleId() {
        return USER_HOLDER.get().get("userRole");
    }

    /**
     * 防止内存溢出，当前线程结束，释放资源
     *
     * @author 【B站：程序员晨星】
     */
    public static void clear() {
        USER_HOLDER.remove();
    }

}
