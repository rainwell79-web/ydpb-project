package com.company.ydpb.domain;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
public class MemberVo {
    private String memId;
    private String memName;
    private String birth;
    private String gender;
    private String memPassword;
    private String address;
    private String addressDetail;
    private String tel;
    private String mobile;
    private String email;
    private String newsYn;
    private Timestamp regdate;
}
