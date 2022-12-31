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

$richText = New-Object System.Windows.Forms.RichTextBox
$richText.Location = [System.Drawing.Point]::new(10,10)
$richText.Size = [System.Drawing.Size]::new(364,350)
$richText.Font = [System.Drawing.Font]::new('Calibri', 14)
$richText.Anchor = 'Top','Right','Bottom','Left'
$form.Controls.Add($richText)

$button = New-Object System.Windows.Forms.Button
$button.Location = [System.Drawing.Point]::new(10,400)
$button.Size = [System.Drawing.Size]::new(80,30)
$button.Text = 'Test'
$button.Anchor = 'Bottom','Left'
$button.Add_Click({
    $richText.Clear()
    # write green lines
    Append-ColoredLine $richText Green "GPO: 'gpo_A' has been linked Successfully"
    Append-ColoredLine $richText Green "GPO: 'gpo_B' has been linked Successfully"
    # write red line
    Append-ColoredLine $richText Red "Could not link GPO: 'gpo_C'"

    # insert blank line
    $richText.AppendText([Environment]::NewLine)

    # write various lines in different colors
    'Blue','DarkGoldenrod','DarkCyan','OliveDrab','Chocolate','Crimson' | ForEach-Object {
        Append-ColoredLine $richText $_ "Some text using color '$_'" 
    }
})
$form.Controls.Add($button)

[void] $form.ShowDialog()
$form.Dispose()