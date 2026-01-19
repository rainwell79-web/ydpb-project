package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.GuNewsVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GuNewsMapper {
    int getTotalCount(Criteria cri);
    List<GuNewsVo> getList(Criteria cri);
    void updateCount(Long dsNo);
    GuNewsVo get(Long dsNo);
    int insert(GuNewsVo vo);
    int update(GuNewsVo vo);
    int delete(Long dsNo);
}
