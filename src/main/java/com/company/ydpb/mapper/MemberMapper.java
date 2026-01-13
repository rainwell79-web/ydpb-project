package com.company.ydpb.mapper;

import com.company.ydpb.domain.MemberVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MemberMapper {
    public List<MemberVo> getList();
}
