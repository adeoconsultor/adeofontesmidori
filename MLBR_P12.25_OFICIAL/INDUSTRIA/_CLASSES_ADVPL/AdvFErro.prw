User Function AdvFError( nFError )

Return( nil )

/*
AAdd(aError, {    -1 Operation failed or undefined error
AAdd(aError, {     0 Operation sucess
AAdd(aError, {     1 (Unexpected Error Code)
AAdd(aError, {     2 Unix : Path/File not found
AAdd(aError, {     3 (Unexpected Error Code)
AAdd(aError, {     4 Unix : Bad File Descriptor
AAdd(aError, {     5 Unix : Too many symbolic links encountered while traversing the path.
AAdd(aError, {     6 Unix : Bad address.
AAdd(aError, {     7 Unix : Out of memory.
AAdd(aError, {     8 Unix : No such device or address.
AAdd(aError, {     9 Win : The endpoint mapper database could not be created.
AAdd(aError, {    10 Win : The operation cannot be performed.
AAdd(aError, {    11 Win : The entry is invalid.
AAdd(aError, {    12 Win : There are no more endpoints available from the endpoint mapper.
AAdd(aError, {    13 Win / Unix : Access is denied.
AAdd(aError, {    14 Win : The referenced account is currently disabled and cannot be logged on to.
AAdd(aError, {    15 Win : The user's account has expired.
AAdd(aError, {    16 Win : The referenced account is currently locked out and may not be logged on to.
AAdd(aError, {    17 Win : Indicates a referenced user name and authentication information are valid, but some user account restriction has prevented successful authentication (such as time-of-day restrictions).
AAdd(aError, {    18 Win : Active connections still exist.
AAdd(aError, {    19 Win : A network adapter hardware error occurred.
AAdd(aError, {    20 Win : The network transport endpoint already has an address associated with it.
AAdd(aError, {    21 Win : An address has not yet been associated with the network endpoint.
AAdd(aError, {    22 Win : The specified alias already exists.
AAdd(aError, {    23 Win : When a block of memory is allotted for future updates, such as the memory allocated to hold discretionary access control and primary group information, successive updates may exceed the amount of memory originally allotted. Since quota may already have been charged to several processes that have handles of the object, it is not reasonable to alter the size of the allocated memory. Instead, a request that requires more memory than has been allotted must fail and the ERROR_ALLOTTED_SPACE_EXCEEDED error returned.
AAdd(aError, {    24 Win : The local device name is already in use.
AAdd(aError, {    25 Win : Attempt to create file that already exists.
AAdd(aError, {    26 Win : An attempt was made to perform an initialization operation when initialization has already been completed.
AAdd(aError, {    27 Win : The service is already registered.
AAdd(aError, {    28 Win : The system is currently running with the last-known-good configuration.
AAdd(aError, {    29 Win : The specified Printer handle is already being waited on
AAdd(aError, {    30 Win : The specified program is not a Windows or MS-DOS program.
AAdd(aError, {    31 Win : The storage control blocks were destroyed.
AAdd(aError, {    32 Win : Arithmetic result exceeded 32-bits.
AAdd(aError, {    33 Win : The file system does not support atomic changing of the lock type.
AAdd(aError, {    34 Win : The operating system cannot run this application program.
AAdd(aError, {    35 Win : The argument string passed to DosExecPgm is incorrect.
AAdd(aError, {    36 Win : The device does not recognize the command.
AAdd(aError, {    37 Win : Indicates a security descriptor is not in the required format (absolute or self-relative).
AAdd(aError, {    38 Win : The network resource type is incorrect.
AAdd(aError, {    39 Win : The specified device name is invalid.
AAdd(aError, {    40 Win : The specified driver is invalid.
AAdd(aError, {    41 Win : The system does not support the requested command.
AAdd(aError, {    42 Win : The environment is incorrect.
AAdd(aError, {    43 Win : 1 is not a valid Windows-based application.
AAdd(aError, {    44 Win : An attempt was made to load a program with an incorrect format.
AAdd(aError, {    45 Win : A specified impersonation level is invalid. Also used to indicate a required impersonation level was not provided.
AAdd(aError, {    46 Win : Indicates that an attempt to build either an inherited ACL or ACE did not succeed. One of the more probable causes is the replacement of a CreatorId with an SID that didn't fit into the ACE or ACL.
AAdd(aError, {    47 Win : The program issued a command but the command length is incorrect.
AAdd(aError, {    48 Win : The logon session is not in a state consistent with the requested operation.
AAdd(aError, {    49 Win : The network name cannot be found.
AAdd(aError, {    50 Win : The specified server cannot perform the requested operation.
AAdd(aError, {    51 Win : The network path was not found.
AAdd(aError, {    52 Win / Unix : The specified path and/or name is invalid
AAdd(aError, {    53 Win : The pipe state is invalid.
AAdd(aError, {    54 Win : The network connection profile is damaged.
AAdd(aError, {    55 Win : The specified network provider name is invalid.
AAdd(aError, {    56 Win : The remote adapter is not compatible.
AAdd(aError, {    57 Win : The address for the thread ID is incorrect.
AAdd(aError, {    58 Win : The type of token object is inappropriate for its attempted use.
AAdd(aError, {    59 Win : The system cannot find the specified device.
AAdd(aError, {    60 Win : The specified user name is invalid.
AAdd(aError, {    61 Win : The requested validation information class is invalid.
AAdd(aError, {    62 Win : The configuration registry database is damaged.
AAdd(aError, {    63 Win : The configuration registry key is invalid.
AAdd(aError, {    64 Win : The beginning of the tape or partition was encountered.
AAdd(aError, {    65 Win : The current boot has already been accepted for use as the last-known-good control set.
AAdd(aError, {    66 Win : The pipe was ended.
AAdd(aError, {    67 Win : The file name is too long.
AAdd(aError, {    68 Win : The I/O bus was reset.
AAdd(aError, {    69 Win : The requested resource is in use.
AAdd(aError, {    70 Win : The system cannot perform a JOIN or SUBST at this time.
AAdd(aError, {    71 Win : The Application Program Interface (API) entered will only work in Windows/NT mode.
AAdd(aError, {    72 Win : Cannot complete function for some reason.
AAdd(aError, {    73 Win : The local WINS can not be deleted.
AAdd(aError, {    74 Win : A lock request was not outstanding for the supplied cancel region.
AAdd(aError, {    75 Win : The operation was cancelled by the user.
AAdd(aError, {    76 Win : The Copy API cannot be used.
AAdd(aError, {    77 Win : Cannot find window class.
AAdd(aError, {    78 Win : Indicates that an attempt was made to impersonate via a named pipe was not yet read from.
AAdd(aError, {    79 Win : The directory or file cannot be created.
AAdd(aError, {    80 Win : Unable to open the network connection profile.
AAdd(aError, {    81 Win : Indicates a domain controller could not be contacted or that objects within the domain are protected and necessary information could not be retrieved.
AAdd(aError, {    82 Win : A mandatory group cannot be disabled.
AAdd(aError, {    83 Win : An attempt was made to open an anonymous level token. Anonymous tokens cannot be opened.
AAdd(aError, {    84 Win : The configuration registry key cannot be opened.
AAdd(aError, {    85 Win : The configuration registry key cannot be read.
AAdd(aError, {    86 Win : The configuration registry key cannot be written.
AAdd(aError, {    87 Win : An attempt was made to create a stable subkey under a volatile parent key.
AAdd(aError, {    88 Win : The %1 application cannot be run in Windows mode.
AAdd(aError, {    89 Win : Child windows can't have menus.
AAdd(aError, {    90 Win : Circular service dependency was specified.
AAdd(aError, {    91 Win : Class already exists.
AAdd(aError, {    92 Win : Class does not exist.
AAdd(aError, {    93 Win : Class still has open windows.
AAdd(aError, {    94 Win : Thread doesn't have clipboard open.
AAdd(aError, {    95 Win : The requested clipping operation is not supported.
AAdd(aError, {    96 Win : The paging file is too small for this operation to complete.
AAdd(aError, {    97 Win : The network connection was aborted by the local system.
AAdd(aError, {    98 Win : An invalid operation was attempted on an active network connection.
AAdd(aError, {    99 Win : A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.
AAdd(aError, {   100 Win : An operation was attempted on a non-existent network connection.
AAdd(aError, {   101 Win : The remote system refused the network connection.
AAdd(aError, {   102 Win : The device is not currently connected but is a remembered connection.
AAdd(aError, {   103 Win : Return that wants caller to continue with work in progress.
AAdd(aError, {   104 Win : Control ID not found.
AAdd(aError, {   105 Win : A serial I/O operation completed because the time-out period expired. (The IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)
AAdd(aError, {   106 Win : Data error (cyclic redundancy check).
AAdd(aError, {   107 Win : The directory cannot be removed.
AAdd(aError, {   108 Win : The database specified does not exist.
AAdd(aError, {   109 Win : Invalid HDC passed to ReleaseDC.
AAdd(aError, {   110 Win : An error occurred in sending the command to the application.
AAdd(aError, {   111 Win : A stop control has been sent to a service which other running services are dependent on.
AAdd(aError, {   112 Win : Cannot destroy object created by another thread.
AAdd(aError, {   113 Win : The specified network resource is no longer available.
AAdd(aError, {   114 Win : An attempt was made to remember a device that was previously remembered.
AAdd(aError, {   115 Win : The device is in use by an active process and cannot be disconnected.
AAdd(aError, {   116 Win : Tape partition information could not be found when loading a tape.
AAdd(aError, {   117 Win : The account specified for this service is different from the account specified for other services running in the same process.
AAdd(aError, {   118 Win / Unix : The directory is not empty.
AAdd(aError, {   119 Win : The directory is not a subdirectory of the root directory.
AAdd(aError, {   120 Win : Attempt to use a file handle to an open disk partition for an operation other than raw disk I/O.
AAdd(aError, {   121 Win / Unix : The directory name is invalid.
AAdd(aError, {   122 Win : The segment is already discarded and cannot be locked.
AAdd(aError, {   123 Win : Program stopped because alternate disk was not inserted.
AAdd(aError, {   124 Win : The disk structure is damaged and nonreadable.
AAdd(aError, {   125 Win : There is not enough space on the disk.
AAdd(aError, {   126 Win : While accessing the hard disk, a disk operation failed even after retries.
AAdd(aError, {   127 Win : While accessing the hard disk, a recalibrate operation failed, even after retries.
AAdd(aError, {   128 Win : While accessing the hard disk, a disk controller reset was needed, but even that failed.
AAdd(aError, {   129 Win : A DLL initialization routine failed.
AAdd(aError, {   130 Win : One of the library files needed to run this application cannot be found.
AAdd(aError, {   131 Win : Could not find the domain controller for this domain.
AAdd(aError, {   132 Win : The specified domain already exists.
AAdd(aError, {   133 Win : An attempt to exceed the limit on the number of domains per server for this release.
AAdd(aError, {   134 Win : The name or security ID (SID) of the domain specified is inconsistent with the trust information for that domain.
AAdd(aError, {   135 Win : The disk is in use or locked by another process.
AAdd(aError, {   136 Win : The workgroup or domain name is already in use by another computer on the network.
AAdd(aError, {   137 Win : A duplicate name exists on the network.
AAdd(aError, {   138 Win : The name is already in use as either a service name or a service display name.
AAdd(aError, {   139 Win : The operating system cannot run this application program.
AAdd(aError, {   140 Win : Access to the EA is denied.
AAdd(aError, {   141 Win : The EA file on the mounted file system is damaged.
AAdd(aError, {   142 Win : The EAs are inconsistent.
AAdd(aError, {   143 Win : The EA table in the EA file on the mounted file system is full.
AAdd(aError, {   144 Win : The EAs did not fit in the buffer.
AAdd(aError, {   145 Win : The mounted file system does not support extended attributes.
AAdd(aError, {   146 Win : The physical end of the tape has been reached.
AAdd(aError, {   147 Win : The system could not find the environment option entered.
AAdd(aError, {   148 Win : Physical end of tape encountered.
AAdd(aError, {   149 Win : No event log file could be opened, so the event logging service did not start.
AAdd(aError, {   150 Win : The event log file has changed between reads.
AAdd(aError, {   151 Win : One of the Eventlog logfiles is damaged.
AAdd(aError, {   152 Win : An exception occurred in the service when handling the control request.
AAdd(aError, {   153 Win : The exclusive semaphore is owned by another process.
AAdd(aError, {   154 Win : The operating system cannot run %1.
AAdd(aError, {   155 Win : An extended error has occurred.
AAdd(aError, {   156 Win : Fail on INT 24.
AAdd(aError, {   157 Win : The service process could not connect to the service controller.
AAdd(aError, {   158 Win : The file or directory is damaged and nonreadable.
AAdd(aError, {   159 Win / Unix : The file exists.
AAdd(aError, {   160 Win / Unix : The volume for a file was externally altered and the opened file is no longer valid.
AAdd(aError, {   161 Win / Unix : The system cannot find the file specified.
AAdd(aError, {   162 Win : A tape access reached a filemark.
AAdd(aError, {   163 Win / Unix : The file name or extension is too long.
AAdd(aError, {   164 Win : The floppy disk controller returned inconsistent results in its registers.
AAdd(aError, {   165 Win : No ID address mark was found on the floppy disk.
AAdd(aError, {   166 Win : Mismatch between the floppy disk sector ID field and the floppy disk controller track address.
AAdd(aError, {   167 Win : The floppy disk controller reported an error that is not recognized by the floppy disk driver.
AAdd(aError, {   168 Win : The backup failed. Check the directory that you are backing the database to.
AAdd(aError, {   169 Win : The requested operation cannot be performed in full-screen mode.
AAdd(aError, {   170 Win : A device attached to the system is not functioning.
AAdd(aError, {   171 Win : Indicates generic access types were contained in an access mask that should already be mapped to non-generic access types.
AAdd(aError, {   172 Win : This hook can only be set globally.
AAdd(aError, {   173 Win : The network connection was gracefully closed.
AAdd(aError, {   174 Win : The specified group already exists.
AAdd(aError, {   175 Win : The disk is full.
AAdd(aError, {   176 Win : Reached End Of File.
AAdd(aError, {   177 Win : Cannot set non-local hook without an module handle.
AAdd(aError, {   178 Win : Hook is not installed.
AAdd(aError, {   179 Win : Hook type not allowed.
AAdd(aError, {   180 Win : The remote system is not reachable by the transport.
AAdd(aError, {   181 Win : Hotkey is already registered.
AAdd(aError, {   182 Win : Hotkey is not registered.
AAdd(aError, {   183 Win : All DeferWindowPos HWNDs must have same parent.
AAdd(aError, {   184 Win : When trying to update a password, this return status indicates the value provided for the new password contains values not allowed in passwords.
AAdd(aError, {   185 Win : The backup failed. Was a full backup done before ?
AAdd(aError, {   186 Win : The network address could not be used for the operation requested.
AAdd(aError, {   187 Win : The operating system cannot run %1.
AAdd(aError, {   188 Win : The data area passed to a system call is too small.
AAdd(aError, {   189 Win : This error indicates the requested operation cannot be completed due to a catastrophic media failure or on-disk data structure corruption.
AAdd(aError, {   190 Win : The Local Security Authority (LSA) database contains in internal inconsistency.
AAdd(aError, {   191 Win : This error indicates the SAM server has encounterred an internal consistency error in its database. This catastrophic failure prevents further operation of SAM.
AAdd(aError, {   192 Win : Invalid accelerator-table handle.
AAdd(aError, {   193 Win : The access code is invalid.
AAdd(aError, {   194 Win : The name provided is not a properly formed account name.
AAdd(aError, {   195 Win : Indicates the ACL structure is not valid.
AAdd(aError, {   196 Win : Attempt to access invalid address.
AAdd(aError, {   197 Win : Cannot request exclusive semaphores at interrupt time.
AAdd(aError, {   198 Win : The storage control block address is invalid.
AAdd(aError, {   199 Win : When accessing a new tape of a multivolume partition, the current block size is incorrect.
AAdd(aError, {   200 Win : The IOCTL call made by the application program is incorrect.
AAdd(aError, {   201 Win : Invalid Message, combo box doesn't have an edit control.
AAdd(aError, {   202 Win : The format of the specified computer name is invalid.
AAdd(aError, {   203 Win : The cursor handle is invalid.
AAdd(aError, {   204 Win : The data is invalid.
AAdd(aError, {   205 Win : The specified datatype is invalid.
AAdd(aError, {   206 Win : One of the library files needed to run this application is damaged.
AAdd(aError, {   207 Win : The format of the specified domain name is invalid.
   208 Win : Indicates the requested operation cannot be completed with the domain in its present role.
   209 Win : Indicates the domain is in the wrong state to perform the desired operation.
   210 Win : The system cannot find the specified drive.
   211 Win : The DeferWindowPos handle is invalid.
   212 Win : The specified EA handle is invalid.
   213 Win : The specified EA name is invalid.
   214 Win : Height must be less than 256.
   215 Win : The Environment specified is invalid.
   216 Win : The number of specified semaphore events is incorrect.
   217 Win : The format of the specified event name is invalid.
   218 Win : 1 cannot be run in Windows/NT mode.
   219 Win : The filter proc is invalid.
   220 Win : The flag passed is incorrect.
   221 Win : The flags are invalid.
   222 Win : The function is incorrect.
   223 Win : The specified attributes are invalid, or incompatible with the attributes for the group as a whole.
   224 Win : The format of the specified group name is invalid.
   225 Win : The GW_* command is invalid.
   226 Win : The specified Form name is invalid.
   227 Win : The specified Form size is invalid
   228 Win : The internal file identifier is incorrect.
   229 Win : The hook filter type is invalid.
   230 Win : The hook handle is invalid.
   231 Win : The icon handle is invalid.
   232 Win : The value provided is an invalid value for an identifier authority.
   233 Win : The index is invalid.
   234 Win : Invalid keyboard layout handle.
   235 Win : The message for single-selection list box is invalid.
   236 Win : The system call level is incorrect.
   237 Win : The list is not correct.
   238 Win : The user account has time restrictions and cannot be logged onto at this time.
   239 Win : Indicates an invalid value has been provided for LogonType has been requested.
   240 Win : A new member could not be added to an alias because the member has the wrong account type.
   241 Win : The menu handle is invalid.
   242 Win : Window can't handle sent message.
   243 Win : The format of the specified message destination is invalid.
   244 Win : The format of the specified message name is invalid.
   245 Win : The operating system cannot run %1.
   246 Win : The operating system cannot run %1.
   247 Win : The message box style is invalid.
   248 Win : The file name, directory name, or volume label is syntactically incorrect.
   249 Win : The format of the specified network name is invalid.
   250 Win : The operating system cannot run %1.
   251 Win : Indicates a particular Security ID cannot be assigned as the owner of an object.
   252 Win : The parameter is incorrect.
   253 Win : The specified network password is incorrect.
   254 Win : The format of the specified password is invalid.
   255 Win : The pixel format is invalid.
   256 Win : Indicates a particular Security ID cannot be assigned as the primary group of an object.
   257 Win : The specified print monitor does not have the required functions.
   258 Win : The printer command is invalid.
   259 Win : The printer name is invalid.
   260 Win : The state of the Printer is invalid
   261 Win : The specified priority is invalid.
   262 Win : Scrollbar range greater than 0x7FFF.
   263 Win : Indicates the SECURITY_DESCRIPTOR structure is invalid.
   264 Win : The operating system cannot run %1.
   265 Win : The system detected a segment number that is incorrect.
   266 Win : The specified separator file is invalid.
   267 Win : Indicates the Sam Server was in the wrong state to perform the desired operation.
   268 Win : The account name is invalid or does not exist.
   269 Win : The requested control is not valid for this service
   270 Win : The specified service database lock is invalid.
   271 Win : The format of the specified service name is invalid.
   272 Win : The format of the specified share name is invalid.
   273 Win : The ShowWindow command is invalid.
   274 Win : Indicates the SID structure is invalid.
   275 Win : The signal being posted is incorrect.
   276 Win : The SPI_* parameter is invalid.
   277 Win : The operating system cannot run %1.
   278 Win : The operating system cannot run %1.
   279 Win : Indicates the sub-authority value is invalid for the particular use.
   280 Win : The target internal file identifier is incorrect.
   281 Win : The thread ID is invalid.
   282 Win : The specified time is invalid.
   283 Win : The supplied user buffer is invalid for the requested operation.
   284 Win : The verify-on-write switch parameter value is incorrect.
   285 Win : The window handle invalid.
   286 Win : The window style or class attribute is invalid for this operation.
   287 Win : The user account is restricted and cannot be used to log on from the source workstation.
   288 Win : The request could not be performed because of an I/O device error.
   289 Win : Overlapped IO event not in signaled state.
   290 Win : Overlapped IO operation in progress.
   291 Win : The operating system is not presently configured to run this application.
   292 Win : Unable to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened.
   293 Win : Not enough resources are available to process this command.
   294 Win : A JOIN or SUBST command cannot be used for a drive that contains previously joined drives.
   295 Win : An attempt was made to use a JOIN or SUBST command on a drive that is already joined.
   296 Win : The path specified is being used in a substitute.
   297 Win : An attempt was made to join or substitute a drive for which a directory on the drive is the target of a previous substitute.
   298 Win : An attempt was made to use a JOIN or SUBST command on a drive already substituted.
   299 Win : The operating system cannot run %1.
   300 Win : The system tried to join a drive to a directory on a joined drive.
   301 Win : The system tried to join a drive to a directory on a substituted drive.
   302 Win : The journal hook is already installed.
   303 Win : Illegal operation attempted on a registry key that has been marked for deletion.
   304 Win : An attempt was made to create a symbolic link in a registry key that already has subkeys or values.
   305 Win : The volume label entered exceeds the 11 character limit. The first 11 characters were written to disk. Any characters that exceeded the 11 character limit were automatically deleted.
   306 Win : Indicates the requested operation would disable or delete the last remaining administration account. This is not allowed to prevent creating a situation where the system will not be administrable.
   307 Win : This list box doesn't support tab stops.
   308 Win : The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.
   309 Win : List box ID not found.
   310 Win : An attempt was made to change a user password in the security account manager without providing the required LM cross-encrypted password.
   311 Win : A user session key was requested for a local RPC connection. The session key returned is a constant value and not unique to this connection.
   312 Win : Attempt to lock a region of a file failed.
   313 Win : The process cannot access the file because another process has locked a portion of the file.
   314 Win : The segment is locked and cannot be reallocated.
   315 Win : The event log file is full.
   316 Win : Attempting to login during an unauthorized time of day for this account.
   317 Win : The account is not authorized to login from this station.
   318 Win : The attempted logon is invalid. This is due to either a bad user name or authentication information.
   319 Win : A requested type of logon, such as Interactive, Network, or Service, is not granted by the target system's local security policy. The system administrator can grant the required form of logon.
   320 Win : The logon session ID is already in use.
   321 Win : An attempt was made to start a new session manager or LSA logon session with an ID already in use.
   322 Win : A user has requested a type of logon, such as interactive or network, that was not granted. An administrator has control over who may logon interactively and through the network.
   323 Win : Indicates there are no more LUID to allocate.
   324 Win : The base address or the file offset specified does not have the proper alignment.
   325 Win : No more threads can be created in the system.
   326 Win : Media in drive may have changed.
   327 Win : The specified account name is not a member of the alias.
   328 Win : The specified user account is already in the specified group account. Also used to indicate a group can not be deleted because it contains a member.
   329 Win : The specified account name is not a member of the alias.
   330 Win : The specified user account is not a member of the specified group account.
   331 Win : Indicates a member cannot be removed from a group because the group is currently the member's primary group.
   332 Win : A menu item was not found.
   333 Win : The global filename characters * or ? are entered incorrectly, or too many global filename characters are specified.
   334 Win : The requested metafile operation is not supported.
   335 Win : The specified module cannot be found.
   336 Win : More data is available.
   337 Win : A serial I/O operation was completed by another write to the serial port. (The IOCTL_SERIAL_XOFF_COUNTER reached zero.)
   338 Win : The system cannot find message for message number 0x%1 in message file for %2.
   339 Win : An attempt was made to move the file pointer before the beginning of the file.
   340 Win : Can't nest calls to LoadModule.
   341 Win : An attempt was made to logon, but the network logon service was not started.
   342 Win : A write fault occurred on the network.
   343 Win : The specified network name is no longer available.
   344 Win : Network access is denied.
   345 Win : The network is busy.
   346 Win : The remote network is not reachable by the transport.
   347 Win : No application is associated with the specified file for this operation.
   348 Win : The list of servers for this workgroup is not currently available
   349 Win : Pipe close in progress.
   350 Win : During a tape access, the end of the data marker was reached.
   351 Win : An attempt was made to operate on an impersonation token by a thread was not currently impersonating a client.
   352 Win : Indicates an ACL contains no inheritable components.
   353 Win : System could not allocate required space in a registry log.
   354 Win : The account used is an interdomain trust account. Use your normal user account or remote user account to access this server.
   355 Win : The account used is an server trust account. Use your normal user account or remote user account to access this server.
   356 Win : There are currently no logon servers available to service the logon request.
   357 Win : The account used is a workstation trust account. Use your normal user account or remote user account to access this server.
   358 Win : Tape query failed because of no media in drive.
   359 Win : No more local devices.
   360 Win : There are no more files.
   361 Win : No more data is available.
   362 Win : No more internal file identifiers available.
   363 Win : No network provider accepted the given network path.
   364 Win : The network is not present or not started.
   365 Win : The system cannot start another process at this time.
   366 Win : No system quota limits are specifically set for this account.
   367 Win : Window does not have scroll bars.
   368 Win : Indicates an attempt was made to operate on the security of an object that does not have security associated with it.
   369 Win : An attempt to abort the shutdown of the system failed because no shutdown was in progress.
   370 Win : No process in the command subtree has a signal handler.
   371 Win : Space to store the file waiting to be printed is not available on the server.
   372 Win : The specified alias does not exist.
   373 Win : The specified domain does not exist.
   374 Win : The specified group does not exist.
   375 Win : A specified logon session does not exist. It may already have been terminated.
   376 Win : A new member cannot be added to an alias because the member does not exist.
   377 Win : A specified authentication package is unknown.
   378 Win : A specified privilege does not exist.
   379 Win : The specified user does not exist.
   380 Win : Window does not have system menu.
   381 Win : Insufficient system resources exist to complete the requested service.
   382 Win : An attempt was made to reference a token that does not exist.
   383 Win : The workstation does not have a trust secret.
   384 Win : The domain controller does not have an account for this workstation.
   385 Win : No mapping for the Unicode character exists in the target multi-byte code page.
   386 Win : There is no user session key for the specified logon session.
   387 Win : The disk has no volume label.
   388 Win : No wildcard characters found.
   389 Win : Invalid access to memory location.
   390 Win : DefMDIChildProc called with a non-MDI child window.
   391 Win : None of the information to be mapped has been translated.
   392 Win : Insufficient system resources exist to complete the requested service.
   393 Win : Indicates not all privileges referenced are assigned to the caller. This allows, for example, all privileges to be disabled without having to know exactly which privileges are assigned.
   394 Win : The operation being requested was not performed because the user has not been authenticated.
   395 Win : Window is not a child window.
   396 Win : This network connection does not exist.
   397 Win : Cannot enumerate a non-container.
   398 Win : The specified disk cannot be accessed.
   399 Win : Not enough storage is available to process this command.
   400 Win : Not enough quota is available to process this command.
   401 Win : Not enough server storage is available to process this command.
   402 Win : The system attempted to delete the JOIN of a drive not previously joined.
   403 Win : The segment is already unlocked.
   404 Win : The operation being requested was not performed because the user has not logged on to the network.
   405 Win : The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.
   406 Win : Attempt to release mutex not owned by caller.
   407 Win : The drive is not ready.
   408 Win : The system attempted to load or restore a file into the registry, and the specified file is not in the format of a registry file.
   409 Win : The system cannot move the file to a different disk drive.
   410 Win : The system attempted to delete the substitution of a drive not previously substituted.
   411 Win : The network request is not supported.
   412 Win : This indicates that a notify change request is being completed and the information is not being returned in the caller's buffer. The caller now needs to enumerate the files to find the changes.
   413 Win : An attempt was made to change a user password in the security account manager without providing the necessary NT cross-encrypted password.
   414 Win : The Windows NT password is too complex to be converted to a Windows-networking password. The Windows-networking password returned is a NULL string.
   415 Win : The specified program requires a newer version of Windows.
   416 Win : The system cannot open the specified device or file.
   417 Win : There are open files or requests pending on this connection.
   418 Win : The I/O operation was aborted due to either thread exit or application request.
   419 Win : The printer is out of paper.
   420 Win : Storage to process this request is not available.
   421 Win : Not enough storage is available to complete this operation.
   422 Win : Insufficient system resources exist to complete the requested service.
   423 Win : Insufficient quota to complete the requested service.
   424 Win : Only part of a Read/WriteProcessMemory request was completed.
   425 Win : Tape could not be partitioned.
   426 Win : The user account's password has expired.
   427 Win : The user must change his password before he logs on the first time.
   428 Win : When trying to update a password, this status indicates that some password update rule was violated. For example, the password may not meet length criteria.
   429 Win : The specified path cannot be used at this time.
   430 Win : The system cannot find the specified path.
   431 Win : All pipe instances busy.
   432 Win : There is a process on other end of the pipe.
   433 Win : Waiting for a process to open the other end of the pipe.
   434 Win : No process on other end of pipe.
   435 Win : Pop-up menu already active.
   436 Win : No service is operating at the destination network endpoint on the remote system.
   437 Win : A potential deadlock condition has been detected.
   438 Win : File waiting to be printed was deleted.
   439 Win : The specified print monitor has already been installed.
   440 Win : The specified print monitor is currently in use.
   441 Win : The specified print processor has already been installed.
   442 Win : The printer already exists.
   443 Win : The specified Printer has been deleted
   444 Win : The specified printer driver is already installed.
   445 Win : The specified printer driver is currently in use.
   446 Win : The requested operation is not allowed when there are jobs queued to the printer.
   447 Win : The printer queue is full.
   448 Win : Using private DIALOG window words.
   449 Win : A required privilege is not held by the client.
   450 Win : The specified procedure could not be found.
   451 Win : The process terminated unexpectedly.
   452 Win : The remote system does not support the transport protocol.
   453 Win : The system cannot read from the specified device.
   454 Win : The name does not exist in the WINS database.
   455 Win : The specified printer or disk device has been paused.
   456 Win : The redirector is in use and cannot be unloaded.
   457 Win : The registry is damaged. The structure of one of the files that contains registry data is damaged, or the system's in memory image of the file is damaged, or the file could not be recovered because its alternate copy or log was absent or damaged.
   458 Win : The registry initiated an I/O operation that had an unrecoverable failure. The registry could not read in, or write out, or flush, one of the files that contain the system's image of the registry.
   459 Win : One of the files containing the system's registry data had to be recovered by use of a log or alternate copy. The recovery succeeded.
   460 Win : The operating system cannot run %1.
   461 Win : The remote computer is not available.
   462 Win : An attempt was made to establish a session to a LAN Manager server, but there are already too many sessions established to that server.
   463 Win : The network request was not accepted.
   464 Win : The request was aborted.
   465 Win : The specified image file did not contain a resource section.
   466 Win : The specified resource language ID cannot be found in the image file.
   467 Win : The specified resource name can not be found in the image file.
   468 Win : The specified resource type can not be found in the image file.
   469 Win : The operation could not be completed.  A retry should be performed.
   470 Win : Indicates two revision levels are incompatible.
   471 Win : The ring 2 stack is in use.
   472 Win : The code segment cannot be greater than or equal to 64KB.
   473 Win : The specified program was written for an older version of Windows.
   474 Win : Replication with a non-configured partner is not allowed.
   475 Win : Indicates an error occurred during a registry transaction commit. The database has been left in an unknown state. The state of the registry transaction is left as COMMITTING. This status value is returned by the runtime library (RTL) registry transaction package (RXact).
   476 Win : Indicates that the transaction state of a registry sub-tree is incompatible with the requested operation. For example, a request has been made to start a new transaction with one already in progress, or a request to apply a transaction when one is not currently in progress. This status value is returned by the runtime library (RTL) registry transaction package (RXact).
   477 Win : The system cannot join or substitute a drive to or for a directory on the same drive.
   478 Win : Screen already locked.
   479 Win : The length of a secret exceeds the maximum length allowed. The length and number of secrets is limited to satisfy the United States State Department export restrictions.
   480 Win : The drive cannot find the requested sector.
   481 Win : The drive cannot locate a specific area or track on the disk.
   482 Win : The file pointer cannot be set on the specified device or file.
   483 Win : The semaphore is set and cannot be closed.
   484 Win : The specified system semaphore name was not found.
   485 Win : The previous ownership of this semaphore has ended.
   486 Win : The semaphore timeout period has expired.
   487 Win : Insert the disk for drive 1.
   488 Win : No serial device was successfully initialized. The serial driver will unload.
   489 Win : The GUID allocation server is already disabled at the moment.
   490 Win : The server is in use and cannot be unloaded.
   491 Win : The GUID allocation server is already enabled at the moment.
   492 Win : An instance of the service is already running.
   493 Win : The service cannot accept control messages at this time.
   494 Win : The service database is locked.
   495 Win : The dependency service does not exist or has been marked for deletion.
   496 Win : The dependency service or group failed to start.
   497 Win : The specified service is disabled and cannot be started.
   498 Win : The specified service does not exist as an installed service.
   499 Win : The specified service already exists.
   500 Win : The service did not start due to a logon failure.
   501 Win : The specified service has been marked for deletion.
   502 Win : No attempts to start the service have been made since the last boot.
   503 Win : A thread could not be created for the service.
   504 Win : The service has not been started.
   505 Win : The specified service does not exist.
   506 Win : The service did not respond to the start or control request in a timely fashion.
   507 Win : The service has returned a service-specific error code.
   508 Win : After starting, the service hung in a start-pending state.
   509 Win : The credentials supplied conflict with an existing set of credentials.
   510 Win : The system BIOS failed an attempt to change the system power state.
   511 Win : An attempt to change the system power state was vetoed by another application or driver.
   512 Win : LB_SETCOUNT sent to non-lazy list box.
   513 Win : A tape access reached a setmark.
   514 Win : Too many files opened for sharing.
   515 Win : The remote server is paused or is in the process of being started.
   516 Win : The process cannot access the file because it is being used by another process.
   517 Win : A system shutdown is in progress.
   518 Win : A signal is already pending.
   519 Win : The recipient process has refused the signal.
   520 Win : Cannot start more than one instance of the specified program.
   521 Win : Some of the information to be mapped has not been translated.
   522 Win : Indicates an operation was attempted on a built-in (special) SAM account that is incompatible with built-in accounts. For example, built-in accounts cannot be renamed or deleted.
   523 Win : The requested operation cannot be performed on the specified group because it is a built-in special group.
   524 Win : The requested operation cannot be performed on the specified user because it is a built-in special user.
   525 Win : An AddJob call was not issued.
   526 Win : A StartDocPrinter call was not issued.
   527 Win : The spool file was not found.
   528 Win : Recursion too deep, stack overflowed.
   529 Win : The importation from the file failed.
   530 Win : The system attempted to SUBST a drive to a directory on a joined drive.
   531 Win : The system attempted to substitute a drive to a directory on a substituted drive.
   532 Win : The operation was successfully completed.
   533 Win : The requested operation is successful. Changes will not be effective until the system is rebooted.
   534 Win : The requested operation is successful. Changes will not be effective until the service is restarted.
   535 Win : Error accessing paging file.
   536 Win : System trace information not specified in your CONFIG.SYS file, or tracing is not allowed.
   537 Win : The requested transformation operation is not supported.
   538 Win : The signal handler cannot be set.
   539 Win : CreateWindow failed, creating top-level window with WS_CHILD style.
   540 Win : An attempt was made to establish a token for use as a primary token but the token is already in use. A token can only be the primary token of one process at a time.
   541 Win : The network BIOS command limit has been reached.
   542 Win : During a logon attempt, the user's security context accumulated too many security IDs. Remove the user from some groups or aliases to reduce the number of security ids to incorporate into the security context.
   543 Win : An attempt was made to create more links on a file than the file system supports.
   544 Win : The number of LUID requested cannot be allocated with a single allocation.
   545 Win : Too many dynamic link modules are attached to this program or dynamic link module.
   546 Win : Too many semaphores are already set.
   547 Win : The name limit for the local computer network adapter card exceeded.
   548 Win : The system cannot open the file.
   549 Win : Too many posts made to a semaphore.
   550 Win : The maximum number of secrets that can be stored in a single system was exceeded. The length and number of secrets is limited to satisfy the United States State Department export restrictions.
   551 Win : The semaphore cannot be set again.
   552 Win : Cannot create another system semaphore.
   553 Win : The network BIOS session limit exceeded.
   554 Win : Too many SIDs specified.
   555 Win : Cannot create another thread.
   556 Win : The network logon failed.
   557 Win : The trust relationship between the primary domain and the trusted domain failed.
   558 Win : The trust relationship between this workstation and the primary domain failed.
   559 Win : Attempt to lock the eject media mechanism failed.
   560 Win : Unload media failed.
   561 Win : An unexpected network error occurred.
   562 Win : The specified port is unknown.
   563 Win : The specified print monitor is unknown.
   564 Win : The print processor is unknown.
   565 Win : The printer driver is unknown.
   566 Win : Indicates an encountered or specified revision number is not one known by the service. The service may not be aware of a more recent revision.
   567 Win : The disk media is not recognized. It may not be formatted.
   568 Win : The volume does not contain a recognized file system. Make sure that all required file system drivers are loaded and the volume is not damaged.
   569 Win : The specified user already exists.
   570 Win : The requested operation cannot be performed on a file with a user mapped section open.
   571 Win : The session was canceled.
   572 Win : There are no child processes to wait for.
   573 Win : The window is not a combo box.
   574 Win : The window is not a valid dialog window.
   575 Win : Invalid window, belongs to other thread.
   576 Win : WINS encountered an error while processing the command.
   577 Win : Insufficient quota to complete the requested service.
   578 Win : The system cannot write to the specified device.
   579 Win : The media is write protected.
   580 Win : The wrong disk is in the drive. Insert %2 (Volume Serial Number: %3) into drive %1.
   581 Win : When trying to update a password, this return status indicates the value provided as the current password is incorrect.
   582 Win : Invalid input handle.
   583 Win : Invalid output handle.
   584 Win : Input parameter out of acceptable range.
   585 Win : Insufficient memory for LZFile structure.
   586 Win : Bad global handle.
   587 Win : Corrupt compressed file format.
   588 Win : Out of space for output file.
   589 Win : Compression algorithm not recognized.
   590 Win : No error.
   591 Win : The object specified was not found.
   592 Win : The object exporter specified was not found.
   593 Win : The object resolver set specified was not found.
   594 Win : An addressing error occurred in the server.
   595 Win : The server is already listening.
   596 Win : The object UUID already registered.
   597 Win : The binding does not contain any authentication information.
   598 Win : The binding handle does not contain all required information.
   599 Win : The server was altered while processing this call.
   600 Win : The remote procedure call failed.
   601 Win : The remote procedure call failed and did not execute.
   602 Win : A remote procedure call is already in progress for this thread.
   603 Win : The requested operation is not supported.
   604 Win : The endpoint cannot be created.
   605 Win : Communications failure.
   606 Win : The endpoint is a duplicate.
   607 Win : The entry already exists.
   608 Win : The entry is not found.
   609 Win : A floating point operation at the server caused a divide by zero.
   610 Win : A floating point overflow occurred at the server.
   611 Win : A floating point underflow occurred at the server.
   612 Win : The group member was not found.
   613 Win : The entry name is incomplete.
   614 Win : The interface was not found.
   615 Win : An internal error occurred in RPC.
   616 Win : The security context is invalid.
   617 Win : The binding handle is invalid.
   618 Win : The array bounds are invalid.
   619 Win : The endpoint format is invalid.
   620 Win : The name syntax is invalid.
   621 Win : The network address is invalid.
   622 Win : The network options are invalid.
   623 Win : The object universal unique identifier (UUID) is the nil UUID.
   624 Win : The RPC protocol sequence is invalid.
   625 Win : The string binding is invalid.
   626 Win : The string UUID is invalid.
   627 Win : The tag is invalid.
   628 Win : The timeout value is invalid.
   629 Win : The version option is invalid.
   630 Win : The maximum number of calls is too small.
   631 Win : The name service is unavailable.
   632 Win : There are no bindings.
   633 Win : There is not a remote procedure call active in this thread.
   634 Win : No security context is available to allow impersonation.
   635 Win : No endpoint was found.
   636 Win : The binding does not contain an entry name.
   637 Win : There are no more bindings.
   638 Win : There are no more members.
   639 Win : No principal name registered.
   640 Win : There are no protocol sequences.
   641 Win : No protocol sequences were registered.
   642 Win : The server is not listening.
   643 Win : There is nothing to unexport.
   644 Win : Thread is not cancelled.
   645 Win : The error specified is not a valid Windows RPC error code.
   646 Win : The object UUID was not found.
   647 Win : Not enough resources are available to complete this operation.
   648 Win : The procedure number is out of range.
   649 Win : An RPC protocol error occurred.
   650 Win : The RPC protocol sequence was not found.
   651 Win : The RPC protocol sequence is not supported.
   652 Win : A security package specific error occurred.
   653 Win : Some data remains to be sent in the request buffer.
   654 Win : The server has insufficient memory to complete this operation.
   655 Win : The server is too busy to complete this operation.
   656 Win : The server is unavailable.
   657 Win : The string is too long.
   658 Win : The type UUID is already registered.
   659 Win : The authentication level is unknown.
   660 Win : The authentication service is unknown.
   661 Win : The authentication type is unknown.
   662 Win : The authorization service is unknown.
   663 Win : The interface is unknown.
   664 Win : The manager type is unknown.
   665 Win : The requested authentication level is not supported.
   666 Win : The name syntax is not supported.
   667 Win : The transfer syntax is not supported by the server.
   668 Win : The type UUID is not supported.
   669 Win : A UUID that is valid only on this computer has been allocated.
   670 Win : No network address is available to use to construct a UUID.
   671 Win : The binding handle is the incorrect type.
   672 Win : The server attempted an integer divide by zero.
   673 Win : The stub received bad data.
   674 Win : The byte count is too small.
   675 Win : The enumeration value is out of range.
   676 Win : Invalid operation on the encoding/decoding handle.
   677 Win : The idl pipe object is invalid or corrupted.
   678 Win : The operation is invalid for a given idl pipe object.
   679 Win : The list of servers available for auto_handle binding was exhausted.
   680 Win : A null reference pointer was passed to the stub.
   681 Win : The stub is unable to get the call handle.
   682 Win : The file designated by DCERPCCHARTRANS cannot be opened.
   683 Win : The file containing the character translation table has fewer than 512 bytes.
   684 Win : The context handle changed during a call.
   685 Win : The context handle does not match any known context handles.
   686 Win : The binding handles passed to a remote procedure call do not match.
   687 Win : A null context handle is passed as an [in] parameter.
   688 Win : Incompatible version of the serializing package.
   689 Win : The idl pipe version is not supported.
   690 Win : Incompatible version of the RPC stub. */