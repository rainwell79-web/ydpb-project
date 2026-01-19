package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import com.company.ydpb.domain.FileVo;

import java.util.List;

public interface DongNewsService {
    int getTotalCount(Criteria cri);
    List<DongNewsVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void increaseCount(Long bno);
    DongNewsVo view(Long bno);
    int write(DongNewsVo vo);
    int edit(DongNewsVo vo);
    int delete(Long bno);
}
