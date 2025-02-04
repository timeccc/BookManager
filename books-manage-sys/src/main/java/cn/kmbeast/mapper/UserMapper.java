package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.UserQueryDto;
import cn.kmbeast.pojo.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户持久化接口
 */
public interface UserMapper {


    /**
     * 用户信息新增
     *
     * @param userInsert 用户信息
     * @return int 受影响行数
     */
    int insert(User userInsert);

    /**
     * 分页查询用户信息
     *
     * @param userQueryDto 分页查询参数
     * @return List<User>
     */
    List<User> query(UserQueryDto userQueryDto);

    /**
     * 查询满足分页查询的记录总数
     *
     * @param userQueryDto 分页查询参数
     * @return int 数据总数
     */
    int queryCount(UserQueryDto userQueryDto);

    /**
     * 更新用户信息
     *
     * @param user 用户信息
     * @return int 受影响行数
     */
    int update(User user);

    /**
     * 批量删除用户信息
     *
     * @param ids 用户ID集合
     */
    void batchDelete(@Param(value = "ids") List<Integer> ids);

    /**
     * 根据不为空的查询信息查找用户
     *
     * @param user 参数
     * @return User
     */
    User getByActive(User user);

}
