import os
import pandas as pd
import matplotlib.pyplot as plt

ANNOTATION_THRESHOLD = 0.2  

plt.rcParams.update({
    "font.size": 16,
    "axes.titlesize": 18,
    "axes.labelsize": 16,
    "xtick.labelsize": 14,
    "ytick.labelsize": 14,
    "legend.fontsize": 14
})

folder = os.getcwd()
out_folder = os.path.join(folder, "HR-bar-graphs")
os.makedirs(out_folder, exist_ok=True)

for file in os.listdir(folder):
    if file.endswith(".csv"):
        filepath = os.path.join(folder, file)
        df = pd.read_csv(filepath)

        if not {"Freq (cm-1)", "HR-factor"}.issubset(df.columns):
            print(f"File {file} does not have the expected columns.")
            continue

        freqs = df["Freq (cm-1)"]
        hr = df["HR-factor"]

        plt.figure(figsize=(12, 6))

        annotated_freqs = []
        offset = 0.1
        Y_MAX = 2.8

        for f, h in zip(freqs, hr):
            if h > 0:
                plt.vlines(f, 0, h, color="#001ac3", linewidth=2)

                if h >= ANNOTATION_THRESHOLD:
                    if annotated_freqs:
                        if f - annotated_freqs[-1] < 500:
                            offset += 0.3
                        else:
                            offset = 0.1
                    else:
                        offset = 0.1

                    if offset > 2:
                        offset = 0.1

                    if h + offset > Y_MAX:
                        xytext = (f + 100, h - 0.07)
                    else:
                        xytext = (f, h + offset)

                    plt.annotate(
                        f"{f:.0f} cm⁻¹",
                        xy=(f, h),
                        xytext=xytext,
                        ha="center" if xytext[0]==f else "left",
                        va="bottom",
                        arrowprops=dict(arrowstyle="->", color="black", lw=1),
                        fontsize=12
                    )
                    annotated_freqs.append(f)

        plt.xlim(10, 3750)
        plt.ylim(0, Y_MAX)
        plt.xlabel("Frequency (cm⁻¹)")
        plt.ylabel("HR-factor")
        plt.title(file.replace(".csv", ""))
        plt.xticks(range(0, 3800, 250))

        outname = os.path.join(out_folder, file.replace(".csv", ".png"))
        plt.tight_layout()
        plt.savefig(outname, dpi=300)
        plt.close()

        print(f"Figure saved: {outname}")
