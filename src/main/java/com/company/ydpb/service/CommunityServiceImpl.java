package com.company.ydpb.service;

import com.company.ydpb.domain.CommunityVo;
import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.mapper.CommunityMapper;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommunityServiceImpl implements CommunityService {
    @Setter(onMethod_ = @Autowired)
    private CommunityMapper mapper;

    @Override
    public int getTotalCount(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<CommunityVo> getList(Criteria cri) {
        return mapper.getList(cri);
    }

    @Override
    public List<FileVo> getFiles(Long bno) {
        return mapper.getFiles(bno);
    }

    @Override
    public void increaseCount(Long bno) {
        mapper.updateCount(bno);
    }

    @Override
    public CommunityVo view(Long bno) {
        return mapper.get(bno);
    }

    @Override
    public int write(CommunityVo vo) {
        return mapper.insert(vo);
    }

    @Override
    public int edit(CommunityVo vo) {
        return mapper.update(vo);
    }

    @Override
    public int delete(Long bno) {
        return mapper.delete(bno);
    }
}
