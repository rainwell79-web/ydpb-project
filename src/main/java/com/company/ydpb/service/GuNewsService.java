package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.GuNewsVo;

import java.util.List;

public interface GuNewsService {
    int getTotalCount(Criteria cri);
    List<GuNewsVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void increaseCount(Long dsNo);
    GuNewsVo view(Long dsNo);
    int write(GuNewsVo vo);
    int edit(GuNewsVo vo);
    int delete(Long dsNo);
}
