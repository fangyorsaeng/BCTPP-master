report 50001 "Report Delete Vendor"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            trigger OnAfterGetRecord()
            begin
                Vendor.Delete(true);
            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }
}