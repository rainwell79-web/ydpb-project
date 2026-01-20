package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import com.company.ydpb.domain.FileVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DongNewsMapper {
    int getTotalCount(Criteria cri);
    List<DongNewsVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void updateCount(Long bno);
    DongNewsVo get(Long bno);
    int insert(DongNewsVo vo);
    int update(DongNewsVo vo);
    int delete(Long bno);
}
