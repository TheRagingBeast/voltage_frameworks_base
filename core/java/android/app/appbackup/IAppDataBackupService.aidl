/*
 * Copyright (C) 2026 VoltageOS
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.app.appbackup;

import android.app.appbackup.AppBackupInfo;
import android.app.appbackup.BackupRecord;
import android.app.appbackup.BackupResult;
import android.app.appbackup.IBackupProgressCallback;
import android.app.appbackup.IRestoreProgressCallback;

/**
 *
 * @hide
 */
interface IAppDataBackupService {

    List<AppBackupInfo> getInstalledApps(int userId);

    List<BackupRecord> getAvailableBackups(String backupDir, int userId);

    String backupPackages(in List<String> packageNames,
                          String backupDir,
                          boolean excludeCache,
                          int userId,
                          IBackupProgressCallback callback,
                          String passphrase,
                          int components,
                          int keepVersions);

    String restorePackages(in List<String> backupIds,
                           String backupDir,
                           int userId,
                           IRestoreProgressCallback callback,
                           String passphrase);

    void cancelOperation(String operationToken);

    boolean deleteBackup(String backupId, String backupDir);

    BackupRecord getBackupRecord(String backupId, String backupDir);

    boolean isEncryptionAvailable(int userId);

    String verifyBackup(String backupId, String backupDir, int userId, String passphrase);

    /**
     * Copy the stored backup.tar for {@code packageName} from
     * /data/misc_ce/<userId>/app_backup/<pkg>/backup.tar to {@code destPath}
     * on /sdcard (or any path the caller resolves).  The service opens the
     * destination file and passes the fd to installd so installd never needs
     * direct access to /sdcard paths.
     */
    void exportAppBackup(String packageName, int userId, String destPath);

    /**
     * Copy a backup.tar from {@code srcPath} (on /sdcard or elsewhere) into
     * /data/misc_ce/<userId>/app_backup/<pkg>/backup.tar.  The service opens
     * the source file and passes the fd to installd.
     */
    void importAppBackup(String packageName, int userId, String srcPath);

    /**
     * Import a raw backup.tar from {@code srcPath} and immediately restore it
     * into the app's live CE+DE data directories. The APK must already be
     * installed. Returns a {@link BackupResult} describing success or failure.
     */
    android.app.appbackup.BackupResult importAndRestore(String packageName,
            int userId, String srcPath);
}
