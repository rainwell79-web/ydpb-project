package com.company.ydpb.domain;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class FileVo {
    private Long fileId;
    private String fileName;
    private String filePath;
    private Long bno;

    public String getFileType() {
        String[] arr = this.fileName.split("\\.");
        return arr[arr.length - 1];
    }
}
