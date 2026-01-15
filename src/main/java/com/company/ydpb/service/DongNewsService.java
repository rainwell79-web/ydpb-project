package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;

import java.util.List;

public interface DongNewsService {
    int getTotalCount(Criteria cri);
    List<DongNewsVo> getList(Criteria cri);
    void increaseCount(Long dsNo);
    DongNewsVo view(Long dsNo);
    int write(DongNewsVo vo);
    int edit(DongNewsVo vo);
    int delete(Long dsNo);
}
