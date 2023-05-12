pageextension 50026 "Sales Quote List" extends "Sales Quotes"
{
    layout
    {
        modify("Posting Date") { Visible = false; }
        modify("Due Date") { Visible = false; }
        modify("External Document No.") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Location Code") { Visible = false; }
        modify("Quote Valid Until Date") { Visible = false; }
        addbefore("External Document No.")
        {
            field("Remark HD"; "Remark HD") { ApplicationArea = all; }
        }
        modify("Document Date") { Visible = true; }
        moveafter("No."; "Document Date")
        addafter("Location Code")
        {
            field("Drawing and Material"; "Drawing and Material") { ApplicationArea = all; }
            // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code") { ApplicationArea = all; }
            // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code") { ApplicationArea = all; }
            field("Create By"; "Create By") { ApplicationArea = all; }
            field("Create Date"; "Create Date") { ApplicationArea = all; }
        }
        modify("Shortcut Dimension 1 Code") { Visible = true; }
        modify("Shortcut Dimension 2 Code") { Visible = true; }
        modify(Status) { Visible = true; }

    }
}