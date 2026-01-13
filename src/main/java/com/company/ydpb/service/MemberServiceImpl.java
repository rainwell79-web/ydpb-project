package com.company.ydpb.service;

import com.company.ydpb.domain.MemberVo;
import com.company.ydpb.mapper.MemberMapper;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {
    @Autowired
    private MemberMapper mapper;

    @Override
    public List<MemberVo> getList() {
        return mapper.getList();
    }
}
