package com.company.ydpb.service;

import com.company.ydpb.domain.CommunityVo;
import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;

import java.util.List;

public interface CommunityService {
    int getTotalCount(Criteria cri);
    List<CommunityVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void increaseCount(Long bno);
    CommunityVo view(Long bno);
    int write(CommunityVo vo);
    int edit(CommunityVo vo);
    int delete(Long bno);
}
