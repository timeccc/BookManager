package cn.kmbeast.utils;


import io.jsonwebtoken.*;

import java.util.Date;
import java.util.UUID;

/**
 * jwt token 工具类
 *
 * @author 【B站：程序员晨星】
 */
public class JwtUtil {
    /**
     * 密钥
     */
    private static final String privateKey = "d8c986df-8512-42b5-906f-eeea9b3acf86";
    /**
     * 有效期一周 --> 时间戳
     */
    private static final Integer time = 1000 * 60 * 60 * 24 * 7;

    /**
     * 生成 token
     *
     * @param id 用户ID
     * @return String
     */
    public static String toToken(Integer id, Integer role) {
        JwtBuilder jwtBuilder = Jwts.builder();
        return jwtBuilder.setHeaderParam("typ", "JWT")
                .setHeaderParam("alg", "HS256")
                .claim("id", id)
                .claim("role", role)
                .setSubject("用户认证")
                .setExpiration(new Date(System.currentTimeMillis() + time))
                .setId(UUID.randomUUID().toString())
                .signWith(SignatureAlgorithm.HS256, privateKey)
                .compact();
    }

    /**
     * 解密TOKEN
     *
     * @param token token信息
     */
    public static Claims fromToken(String token) {
        JwtParser jwtParser = Jwts.parser();
        Jws<Claims> claimsJws;
        try {
            claimsJws = jwtParser.setSigningKey(privateKey).parseClaimsJws(token);
            return claimsJws.getBody();
        } catch (Exception e) {
            return null;
        }
    }

}
