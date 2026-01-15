package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DongNewsMapper {
    public int getTotalCount(Criteria cri);
    public List<DongNewsVo> getList(Criteria cri);
    public void updateCount(Long dsNo);
    public DongNewsVo get(Long dsNo);
    public int insert(DongNewsVo vo);
    public int update(DongNewsVo vo);
    public int delete(Long dsNo);
}
