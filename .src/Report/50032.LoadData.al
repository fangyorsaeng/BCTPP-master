report 50032 "Load Data Item On Report"
{
    ProcessingOnly = true;
    dataset
    {
        dataitem("Plan Header"; "Plan Header")
        {
            RequestFilterFields = "Plan Name";
            column(Plan_Name; "Plan Name") { }
            trigger OnAfterGetRecord()
            begin
                //Message("Plan Header"."Plan Name");
                CopyItemToPlanLine("Plan Header"."Plan Name");
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(GroupName; GroupCode)
                    {
                        ApplicationArea = all;
                        Caption = 'Group Name';
                    }
                    field(Section; Section)
                    {
                        ApplicationArea = all;
                        Caption = 'Section';
                    }
                    field(ReportType; ReportType)
                    {
                        ApplicationArea = all;
                        Caption = 'Report Type';
                    }
                    field(Update; CUpdate)
                    {
                        Caption = 'Calc. Update';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        if Format(Section) = '' then
            Error('Please Select Section!');
        if GroupCode = '' then
            Error('Please Insert Group Name');
        //if ReportType = 0 then
        //    Error('Please Select Report Type!');

    end;

    var
        Section: Enum "Prod. Process";
        ReportType: Option " ",Sales,Factory,Supplier;
        GroupCode: Code[30];
        CUpdate: Boolean;

    procedure CopyItemToPlanLine(DocNo: Code[50])
    var
        PlanH: Record "Plan Header";
        PlanLine: Record "Plan Line Sub";
        PlanLine2: Record "Plan Line Sub";
        ItemOnReport: Record "List Item On Report";
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", DocNo);
        if PlanH.Find('-') then begin
            PlanLine.Reset();
            PlanLine.SetRange("ref. Plan Name", DocNo);
            if PlanLine.Find('-') then begin
                if NOT CUpdate then
                    PlanLine.DeleteAll();
            end;


            ItemOnReport.Reset();
            ItemOnReport.SetRange("Group PD", Section);
            ItemOnReport.SetRange("Group Name", GroupCode);
            if ReportType <> ReportType::" " then
                ItemOnReport.SetRange("Report Type", ReportType);
            if ItemOnReport.Find('-') then begin
                repeat
                    if NOT CUpdate then begin
                        PlanLine.Reset();
                        PlanLine.Init();
                        PlanLine."ref. Plan Name" := DocNo;
                        PlanLine.Seq := ItemOnReport.Seq;
                        PlanLine."Part No." := ItemOnReport."Part No.";
                        PlanLine."Part Name" := ItemOnReport."Part Name";
                        PlanLine."Type Item" := ItemOnReport."Type Item";
                        PlanLine.Model := '';
                        PlanLine.Section := ItemOnReport."Group PD";
                        PlanLine.EditAble := NOT ItemOnReport.Editable;
                        PlanLine."Report Type" := ItemOnReport."Report Type";
                        PlanLine.Insert();
                    end
                    else begin
                        PlanLine2.Reset();
                        PlanLine2.SetRange(Seq, ItemOnReport.Seq);
                        PlanLine2.SetRange("ref. Plan Name", DocNo);
                        if not PlanLine2.Find('-') then begin
                            PlanLine.Reset();
                            PlanLine.Init();
                            PlanLine."ref. Plan Name" := DocNo;
                            PlanLine.Seq := ItemOnReport.Seq;
                            PlanLine."Part No." := ItemOnReport."Part No.";
                            PlanLine."Part Name" := ItemOnReport."Part Name";
                            PlanLine."Type Item" := ItemOnReport."Type Item";
                            PlanLine.Model := '';
                            PlanLine.Section := ItemOnReport."Group PD";
                            PlanLine.EditAble := NOT ItemOnReport.Editable;
                            PlanLine."Report Type" := ItemOnReport."Report Type";
                            PlanLine.Insert();
                        end;
                    end;

                until ItemOnReport.Next = 0;
            end;

        end;
    end;
}