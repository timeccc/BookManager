package cn.kmbeast.pojo.dto.update;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserRegisterDTO {
    /**
     * 用户名
     */
    private String userName;
    /**
     * 账号
     */
    private String userAccount;
    /**
     * 密码
     */
    private String userPwd;
    /**
     * 用户邮箱
     */
    private String userEmail;
    /**
     * 用户头像
     */
    private String userAvatar;
}
