package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.ProposalVo;
import com.company.ydpb.mapper.ProposalMapper;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProposalServiceImpl implements ProposalService {
    @Setter(onMethod_ = @Autowired)
    private ProposalMapper mapper;

    @Override
    public int getTotalCount(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<ProposalVo> getList(Criteria cri) {
        return mapper.getList(cri);
    }

    @Override
    public List<FileVo> getFiles(Long bno) {
        return mapper.getFiles(bno);
    }

    @Override
    public ProposalVo view(Long bno) {
        return mapper.get(bno);
    }

    @Override
    public int write(ProposalVo vo) {
        return mapper.insert(vo);
    }

    @Override
    public int edit(ProposalVo vo) {
        return mapper.update(vo);
    }

    @Override
    public int delete(Long bno) {
        return mapper.delete(bno);
    }
}
