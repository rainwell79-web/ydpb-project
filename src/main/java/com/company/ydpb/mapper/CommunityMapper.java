package com.company.ydpb.mapper;

import com.company.ydpb.domain.CommunityVo;
import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommunityMapper {
    int getTotalCount(Criteria cri);
    List<CommunityVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void updateCount(Long bno);
    CommunityVo get(Long bno);
    int insert(CommunityVo vo);
    int update(CommunityVo vo);
    int delete(Long bno);
}
