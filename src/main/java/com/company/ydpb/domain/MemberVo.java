package com.company.ydpb.domain;

import lombok.Data;

import java.util.Date;

@Data
public class MemberVo {
    private String memId;
    private String memName;
    private String memGender;
    private String memPassword;
    private String memAddress;
    private String memAddress_detail;
    private String memTel;
    private String memMobile;
    private String memEmail;
    private String memNews;
    private Date memRegdate;
}
