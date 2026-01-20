package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.ProposalVo;

import java.util.List;

public interface ProposalService {
    int getTotalCount(Criteria cri);
    List<ProposalVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    ProposalVo view(Long bno);
    int write(ProposalVo vo);
    int edit(ProposalVo vo);
    int delete(Long bno);
}
