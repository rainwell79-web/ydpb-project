package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DongNewsMapper {
    int getTotalCount(Criteria cri);
    List<DongNewsVo> getList(Criteria cri);
    void updateCount(Long dsNo);
    DongNewsVo get(Long dsNo);
    int insert(DongNewsVo vo);
    int update(DongNewsVo vo);
    int delete(Long dsNo);
}
