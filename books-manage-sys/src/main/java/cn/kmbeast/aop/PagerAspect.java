package cn.kmbeast.aop;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class PagerAspect {

    /**
     * 环绕通知，用于处理带有@Pager注解的方法
     *
     * @param joinPoint 连接点
     * @param pager     注解实例
     * @return 原方法执行的结果
     * @throws Throwable 异常
     */
    @Around("@annotation(pager)")
    public Object handlePageableParams(ProceedingJoinPoint joinPoint, Pager pager) throws Throwable {
        Object[] args = joinPoint.getArgs();
        for (Object arg : args) {
            if (arg instanceof QueryDto) {
                QueryDto queryDTO = (QueryDto) arg;
                configPager(queryDTO);
            }
        }
        return joinPoint.proceed(args);
    }

    /**
     * 分页参数转换逻辑
     *
     * @param queryDTO 分页参数DTO
     */
    private void configPager(QueryDto queryDTO) {
        if (queryDTO.getCurrent() != null && queryDTO.getSize() != null) {
            queryDTO.setCurrent((queryDTO.getCurrent() - 1) * queryDTO.getSize());
        }
    }
}
