Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# helper function to write text in a given color 
# to the specified RichTextBox control
function Append-ColoredLine {
    param( 
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Windows.Forms.RichTextBox]$box,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Drawing.Color]$color,
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$text
    )
    $box.SelectionStart = $box.TextLength
    $box.SelectionLength = 0
    $box.SelectionColor = $color
    $box.AppendText($text)
    $box.AppendText([Environment]::NewLine)
}

$form = New-Object System.Windows.Forms.Form
$form.Width = 700
$form.Height = 600

$TabControl = New-Object System.Windows.Forms.TabControl
$TabPage1 = New-Object System.Windows.Forms.TabPage
$TabPage1.Text = 'Тестирование'

$Tab1_Label_ARM = New-Object System.Windows.Forms.Label
$Tab1_Label_ARM.Text = "Введите имя АРМ:"
$Tab1_Label_ARM.Location = New-Object System.Drawing.Point(5,10)
$Tab1_Label_ARM.AutoSize = $true
$TabPage1.Controls.Add($Tab1_Label_ARM)

$Tab1_Edit_ARM = New-Object System.Windows.Forms.TextBox
$Tab1_Edit_ARM.Location = New-Object System.Drawing.Point(108,7)
$Tab1_Edit_ARM.Size = New-Object System.Drawing.Size(150,70)
$TabPage1.Controls.Add($Tab1_Edit_ARM)

$Tab1_Button_Test = New-Object System.Windows.Forms.Button
$Tab1_Button_Test.Location = New-Object System.Drawing.Point(263,7)
$Tab1_Button_Test.Size = New-Object System.Drawing.Size(90,20)
$Tab1_Button_Test.Text = 'Проверить'
#$button.Anchor = 'Bottom','Left'
$TabPage1.Controls.Add($Tab1_Button_Test)

$Tab1_Button_Test.Add_Click({
    #$RichText.Clear()
    $First_Char = $Tab1_Edit_ARM.Text[0]
    if ($First_Char -match '\d.\d.\d.\d') {
        Append-ColoredLine $richText Black "Введен IP адрес"
    } else {
        Append-ColoredLine $richText Black "Введено имя АРМ"
        Append-ColoredLine $richText Black $Tab1_Edit_ARM.Text
        $IP = Resolve-DnsName -Name $Tab1_Edit_ARM.Text -Type A
        $IP_String = "IP адрес - " + [string]$IP.IPAddress
        Append-ColoredLine $richText Black $IP_String
    }
    # write green lines
    #Append-ColoredLine $richText Green $First_Char
    #Append-ColoredLine $richText Green "GPO: 'gpo_B' has been linked Successfully"
    # write red line
    #Append-ColoredLine $richText Red "Could not link GPO: 'gpo_C'"
    # insert blank line
    #$richText.AppendText([Environment]::NewLine)
    # write various lines in different colors
    'Blue','DarkGoldenrod','DarkCyan','OliveDrab','Chocolate','Crimson' | ForEach-Object {
        Append-ColoredLine $richText $_ "Some text using color '$_'" 
    }
})



$TabPage2 = New-Object System.Windows.Forms.TabPage
$TabPage2.Text = 'Установка'


$TabControl.Controls.Add($TabPage1)
$TabControl.Controls.Add($TabPage2)
$TabControl.Location  = New-Object System.Drawing.Point(0,0)
$TabControl.Size = New-Object System.Drawing.Size(683,360)

$form.Controls.add($TabControl)



$richText = New-Object System.Windows.Forms.RichTextBox
$richText.Location = New-Object System.Drawing.Point(1,362)
$richText.Size = New-Object System.Drawing.Size(679,196)
$richText.Font = [System.Drawing.Font]::new('Calibri', 12)
$richText.Anchor = 'Top','Right','Bottom','Left'
$form.Controls.Add($richText)
Append-ColoredLine $richText Black "     ----- Лог выполнения команд -----"

[void] $form.ShowDialog()
$form.Dispose()