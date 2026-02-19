# universal_checker.ps1
# Универсальный сетевой диагностический инструмент
# Проверка: Ping + DNS + Port + HTTP(S) для ЛЮБОГО хоста/порта
# Совместим с PowerShell 5.1+, не требует прав администратора
# Кодировка: сохранить как UTF-8 без BOM

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# TCP Port Check (асинхронный)
function Test-TcpPort {
    param([string]$Target, [int]$Port, [int]$TimeoutMs = 2000)
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $connect = $tcp.BeginConnect($Target, $Port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
        if ($wait) { $tcp.EndConnect($connect); $tcp.Close(); $true } else { $tcp.Close(); $false }
    } catch { $false }
}

# Основная форма
$form = New-Object System.Windows.Forms.Form
$form.Text = "Universal Network Checker v1.1"
$form.Size = New-Object System.Drawing.Size(800, 500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

# Поля ввода
$lblTarget = New-Object System.Windows.Forms.Label
$lblTarget.Text = "Target (IP or FQDN):"
$lblTarget.Location = New-Object System.Drawing.Point(20, 20)
$lblTarget.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblTarget)

$txtTarget = New-Object System.Windows.Forms.TextBox
$txtTarget.Location = New-Object System.Drawing.Point(180, 20)
$txtTarget.Size = New-Object System.Drawing.Size(300, 20)
$txtTarget.PlaceholderText = "example.com or 10.245.0.226"
$form.Controls.Add($txtTarget)

$lblPort = New-Object System.Windows.Forms.Label
$lblPort.Text = "Port:"
$lblPort.Location = New-Object System.Drawing.Point(20, 50)
$lblPort.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblPort)

$txtPort = New-Object System.Windows.Forms.TextBox
$txtPort.Text = "443"
$txtPort.Location = New-Object System.Drawing.Point(180, 50)
$txtPort.Size = New-Object System.Drawing.Size(80, 20)
$form.Controls.Add($txtPort)

$lblPath = New-Object System.Windows.Forms.Label
$lblPath.Text = "HTTP Path (optional):"
$lblPath.Location = New-Object System.Drawing.Point(20, 80)
$lblPath.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblPath)

$txtPath = New-Object System.Windows.Forms.TextBox
$txtPath.Text = "/"
$txtPath.Location = New-Object System.Drawing.Point(180, 80)
$txtPath.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($txtPath)

# Чекбоксы проверок
$chkPing = New-Object System.Windows.Forms.CheckBox
$chkPing.Text = "Ping (ICMP)"
$chkPing.Checked = $true
$chkPing.Location = New-Object System.Drawing.Point(20, 120)
$form.Controls.Add($chkPing)

$chkDNS = New-Object System.Windows.Forms.CheckBox
$chkDNS.Text = "DNS Resolution"
$chkDNS.Checked = $true
$chkDNS.Location = New-Object System.Drawing.Point(150, 120)
$form.Controls.Add($chkDNS)

$chkPort = New-Object System.Windows.Forms.CheckBox
$chkPort.Text = "Port Check"
$chkPort.Checked = $true
$chkPort.Location = New-Object System.Drawing.Point(300, 120)
$form.Controls.Add($chkPort)

$chkHTTP = New-Object System.Windows.Forms.CheckBox
$chkHTTP.Text = "HTTP/HTTPS Health"
$chkHTTP.Checked = $true
$chkHTTP.Location = New-Object System.Drawing.Point(420, 120)
$form.Controls.Add($chkHTTP)

# Кнопки
$btnCheck = New-Object System.Windows.Forms.Button
$btnCheck.Text = "> CHECK"
$btnCheck.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)
$btnCheck.ForeColor = [System.Drawing.Color]::White
$btnCheck.BackColor = [System.Drawing.Color]::FromArgb(46, 170, 72)
$btnCheck.Location = New-Object System.Drawing.Point(20, 160)
$btnCheck.Size = New-Object System.Drawing.Size(150, 40)
$form.Controls.Add($btnCheck)

$btnBatch = New-Object System.Windows.Forms.Button
$btnBatch.Text = "Batch Check (from file)"
$btnBatch.Location = New-Object System.Drawing.Point(180, 160)
$btnBatch.Size = New-Object System.Drawing.Size(200, 40)
$form.Controls.Add($btnBatch)

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Results"
$btnSave.Location = New-Object System.Drawing.Point(390, 160)
$btnSave.Size = New-Object System.Drawing.Size(150, 40)
$form.Controls.Add($btnSave)

# Лог
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Location = New-Object System.Drawing.Point(20, 210)
$txtLog.Size = New-Object System.Drawing.Size(740, 200)
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::Black
$txtLog.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($txtLog)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready | Enter target and port to check"
$statusLabel.Dock = [System.Windows.Forms.DockStyle]::Bottom
$statusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLabel.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)
$form.Controls.Add($statusLabel)

# Основная логика проверки
function Run-Check {
    $target = $txtTarget.Text.Trim()
    $port = $txtPort.Text.Trim()
    $path = $txtPath.Text.Trim()
    
    if (-not $target) { 
        [System.Windows.Forms.MessageBox]::Show("Enter target IP/FQDN!", "Error", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
        return 
    }
    
    if (-not [int]::TryParse($port, [ref]$null)) { 
        [System.Windows.Forms.MessageBox]::Show("Invalid port number!", "Error", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
        return 
    }
    
    $port = [int]$port
    $logFile = "universal_check_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    $txtLog.Clear()
    $txtLog.AppendText("=== UNIVERSAL NETWORK CHECK STARTED ===`n")
    $txtLog.AppendText("Target: $target`n")
    $txtLog.AppendText("Port: $port`n")
    $txtLog.AppendText("Path: $path`n")
    $txtLog.AppendText("Log file: $logFile`n`n")
    
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # Ping
    if ($chkPing.Checked) {
        $txtLog.AppendText("-> PING: $target`n")
        $pingStart = Get-Date
        $pingResult = Test-Connection -ComputerName $target -Count 1 -Quiet -ErrorAction SilentlyContinue
        $pingTime = [math]::Round(((Get-Date) - $pingStart).TotalMilliseconds)
        
        if ($pingResult) {
            $txtLog.AppendText("   [OK] ICMP reachable ($pingTime ms)`n")
        } else {
            $txtLog.AppendText("   [FAIL] ICMP unreachable ($pingTime ms timeout)`n")
        }
    }
    
    # DNS
    if ($chkDNS.Checked -and $target -notmatch '^\d{1,3}(\.\d{1,3}){3}$') {
        $txtLog.AppendText("-> NSLOOKUP: $target`n")
        $dnsStart = Get-Date
        try {
            $dnsResult = Resolve-DnsName $target -Type A -ErrorAction Stop | Select-Object -First 1 -ExpandProperty IPAddress
            $dnsTime = [math]::Round(((Get-Date) - $dnsStart).TotalMilliseconds)
            $txtLog.AppendText("   [OK] Resolved to: $dnsResult ($dnsTime ms)`n")
        } catch {
            $dnsTime = [math]::Round(((Get-Date) - $dnsStart).TotalMilliseconds)
            $txtLog.AppendText("   [FAIL] DNS resolution failed ($dnsTime ms)`n")
        }
    }
    
    # Port
    if ($chkPort.Checked) {
        $txtLog.AppendText("-> PORT CHECK: $target`:$port`n")
        $portStart = Get-Date
        $portOpen = Test-TcpPort -Target $target -Port $port -TimeoutMs 2000
        $portTime = [math]::Round(((Get-Date) - $portStart).TotalMilliseconds)
        
        if ($portOpen) {
            $txtLog.AppendText("   [OK] Port $port is open ($portTime ms)`n")
        } else {
            $txtLog.AppendText("   [FAIL] Port $port is closed/unreachable ($portTime ms timeout)`n")
        }
    }
    
    # HTTP
    if ($chkHTTP.Checked -and $portOpen -and $path) {
        $txtLog.AppendText("-> HTTP CHECK: $target`:$port$path`n")
        $httpStart = Get-Date
        $protocol = if ($port -eq 443) { "https" } else { "http" }
        $url = "{0}://{1}:{2}{3}" -f $protocol, $target, $port, $path
        
        try {
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -UseBasicParsing -ErrorAction Stop
            $httpTime = [math]::Round(((Get-Date) - $httpStart).TotalMilliseconds)
            $txtLog.AppendText("   [OK] HTTP $($response.StatusCode) ($httpTime ms)`n")
        } catch {
            $httpTime = [math]::Round(((Get-Date) - $httpStart).TotalMilliseconds)
            if ($_.Exception.Response) {
                $code = [int]$_.Exception.Response.StatusCode
                $txtLog.AppendText("   [FAIL] HTTP $code ($httpTime ms)`n")
            } else {
                $txtLog.AppendText("   [FAIL] Connection timeout/error ($httpTime ms)`n")
            }
        }
    }
    
    $txtLog.AppendText("`n=== CHECK COMPLETED ===`n")
    $txtLog.Text | Out-File -FilePath $logFile -Encoding UTF8
    $statusLabel.Text = "Check completed! Log: $logFile"
    [System.Windows.Forms.MessageBox]::Show("Check completed!`nLog saved to: $logFile", "Done", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Обработчики кнопок
$btnCheck.Add_Click({ Run-Check })

$btnBatch.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $targets = Get-Content $dlg.FileName | Where-Object { $_ -match '\S' }
        $logFile = "batch_check_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
        $txtLog.Clear()
        $txtLog.AppendText("=== BATCH CHECK STARTED ===`n")
        $txtLog.AppendText("File: $($dlg.FileName)`n")
        $txtLog.AppendText("Targets: $($targets.Count)`n`n")
        
        foreach ($line in $targets) {
            # Формат файла: target,port,path
            $parts = $line -split ','
            $target = $parts[0].Trim()
            $port = if ($parts.Count -gt 1) { $parts[1].Trim() } else { "443" }
            $path = if ($parts.Count -gt 2) { $parts[2].Trim() } else { "/" }
            
            $txtLog.AppendText("[$($target):$port$path]`n")
            
            # Ping
            $pingResult = Test-Connection -ComputerName $target -Count 1 -Quiet -ErrorAction SilentlyContinue
            $txtLog.AppendText("  Ping: $(if ($pingResult) { 'OK' } else { 'FAIL' })`n")
            
            # Port
            $portOpen = Test-TcpPort -Target $target -Port ([int]$port) -TimeoutMs 2000
            $txtLog.AppendText("  Port: $(if ($portOpen) { 'OPEN' } else { 'CLOSED' })`n")
            
            # HTTP (если порт открыт)
            if ($portOpen -and $chkHTTP.Checked) {
                $protocol = if ([int]$port -eq 443) { "https" } else { "http" }
                $url = "{0}://{1}:{2}{3}" -f $protocol, $target, $port, $path
                try {
                    $resp = Invoke-WebRequest -Uri $url -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
                    $txtLog.AppendText("  HTTP: $($resp.StatusCode)`n")
                } catch {
                    $txtLog.AppendText("  HTTP: FAIL`n")
                }
            }
            $txtLog.AppendText("`n")
        }
        
        $txtLog.AppendText("=== BATCH CHECK COMPLETED ===`n")
        $txtLog.Text | Out-File -FilePath $logFile -Encoding UTF8
        $statusLabel.Text = "Batch check completed! Log: $logFile"
    }
})

$btnSave.Add_Click({
    $dlg = New-Object System.Windows.Forms.SaveFileDialog
    $dlg.Filter = "Log files (*.log)|*.log|Text files (*.txt)|*.txt"
    $dlg.FileName = "check_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtLog.Text | Out-File -FilePath $dlg.FileName -Encoding UTF8
        $statusLabel.Text = "Log saved: $($dlg.FileName)"
    }
})

# Горячие клавиши
$form.KeyPreview = $true
$form.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") { Run-Check }
    if ($_.KeyCode -eq "Escape") { $form.Close() }
})

# Запуск формы
$form.ShowDialog() | Out-Null
$form.Dispose()